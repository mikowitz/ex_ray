defmodule ExRay.Camera do
  alias ExRay.{Color, HitRecord, Interval, Utils, Vec}

  defstruct [
    :image_height,
    :center,
    :pixel00_loc,
    :pixel_delta_u,
    :pixel_delta_v,
    :pixels_sample_scale,
    :defocus_disk_u,
    :defocus_disk_v,
    aspect_ratio: 1,
    image_width: 100,
    samples_per_pixel: 10,
    max_depth: 10,
    vfov: 90,
    lookfrom: Vec.new(0, 0, 0),
    lookat: Vec.new(0, 0, -1),
    vup: Vec.new(0, 1, 0),
    defocus_angle: 0,
    focus_dist: 10
  ]

  def new, do: %__MODULE__{}

  def render(%__MODULE__{} = camera, world) do
    %__MODULE__{
      image_width: image_width,
      image_height: image_height
    } = camera = initialize(camera)

    {time, _} =
      :timer.tc(fn ->
        File.open("test.ppm", [:write], fn file ->
          IO.puts(file, "P3\n#{image_width} #{image_height}\n255")

          for y <- 0..(image_height - 1) do
            for x <- 0..(image_width - 1) do
              color = get_pixel_color(x, y, camera, world)
              IO.puts(file, Color.to_ppm(color))

              if rem(y * image_width + x, 1000) == 0 do
                IO.puts("#{y * image_width + x} / #{image_width * image_height}")
              end
            end
          end
        end)
      end)

    time
  end

  def prender(%__MODULE__{} = camera, world) do
    %__MODULE__{
      image_width: image_width,
      image_height: image_height
    } = camera = initialize(camera)

    coords = for y <- 0..(image_height - 1), x <- 0..(image_width - 1), do: {x, y}

    # worker_count = :erlang.system_info(:schedulers_online)
    worker_count = 8

    per_chunk = :erlang.ceil(length(coords) / worker_count)

    {:ok, progress_pid} = ExRay.Progress.start_link(worker_count)

    {time, _} =
      :timer.tc(fn ->
        pixels =
          Enum.chunk_every(coords, per_chunk)
          |> Enum.with_index()
          |> Task.async_stream(&get_pixels_colors(&1, camera, world), timeout: :infinity)
          |> Enum.to_list()
          |> Enum.reduce([], fn {:ok, result}, acc ->
            [result | acc]
          end)
          |> Enum.reverse()
          |> List.flatten()

        File.open("test.ppm", [:write], fn file ->
          IO.puts(file, "P3\n#{image_width} #{image_height}\n255")

          IO.puts(file, Enum.map_join(pixels, "\n", &Color.to_ppm/1))
        end)
      end)

    IO.puts("")
    GenServer.stop(progress_pid)

    time
  end

  defp get_pixels_colors({coords, set_i}, camera, world) do
    l = length(coords)

    coords
    |> Enum.with_index()
    |> Enum.map(fn {{x, y}, i} ->
      ExRay.Progress.update(set_i, round(i * 100 / l))
      get_pixel_color(x, y, camera, world)
    end)
  end

  defp get_pixel_color(x, y, camera, world) do
    Enum.reduce(1..camera.samples_per_pixel, Color.black(), fn _, c ->
      ray = get_ray(camera, x, y)
      Color.add(c, ray_color(ray, camera.max_depth, world))
    end)
    |> Color.mul(camera.pixels_sample_scale)
  end

  defp initialize(%__MODULE__{image_width: image_width, aspect_ratio: aspect_ratio} = camera) do
    image_height = max(round(image_width / aspect_ratio), 1)

    camera_center = camera.lookfrom

    theta = Utils.degrees_to_radians(camera.vfov)
    h = :math.tan(theta / 2)
    viewport_height = 2 * h * camera.focus_dist
    viewport_width = viewport_height * (image_width / image_height)

    w = Vec.sub(camera.lookfrom, camera.lookat) |> Vec.unit_vector()
    u = Vec.cross(camera.vup, w) |> Vec.unit_vector()
    v = Vec.cross(w, u)

    viewport_u = Vec.mul(u, viewport_width)
    viewport_v = Vec.mul(Vec.negate(v), viewport_height)

    pixel_delta_u = Vec.div(viewport_u, image_width)
    pixel_delta_v = Vec.div(viewport_v, image_height)

    viewport_upper_left =
      camera_center
      |> Vec.sub(Vec.mul(w, camera.focus_dist))
      |> Vec.sub(Vec.div(viewport_u, 2))
      |> Vec.sub(Vec.div(viewport_v, 2))

    pixel00_loc =
      viewport_upper_left
      |> Vec.add(Vec.mul(Vec.add(pixel_delta_u, pixel_delta_v), 0.5))

    defocus_radius =
      camera.focus_dist * :math.tan(Utils.degrees_to_radians(camera.defocus_angle / 2))

    defocus_disk_u = Vec.mul(u, defocus_radius)
    defocus_disk_v = Vec.mul(v, defocus_radius)

    %__MODULE__{
      camera
      | image_height: image_height,
        center: camera_center,
        pixel00_loc: pixel00_loc,
        pixel_delta_u: pixel_delta_u,
        pixel_delta_v: pixel_delta_v,
        pixels_sample_scale: 1 / camera.samples_per_pixel,
        defocus_disk_u: defocus_disk_u,
        defocus_disk_v: defocus_disk_v
    }
  end

  defp ray_color(ray, depth, world) do
    if depth <= 0 do
      Color.black()
    else
      case ExRay.Hittable.hit(world, ray, Interval.new(0.001, 1.0e100)) do
        %HitRecord{} = hr ->
          scatter = ExRay.Material.scatter(hr.material, ray, hr)
          Color.mul(ray_color(scatter.ray, depth - 1, world), scatter.attenuation)

        nil ->
          {_ux, uy, _uz} = Vec.unit_vector(ray.direction)
          a = 0.5 * (uy + 1.0)

          Color.white()
          |> Color.mul(1.0 - a)
          |> Color.add(Color.mul(ExRay.color(0.5, 0.7, 1.0), a))
      end
    end
  end

  defp get_ray(%__MODULE__{} = camera, x, y) do
    {rx, ry, _} = sample_square()

    pixel_sample =
      camera.pixel00_loc
      |> Vec.add(Vec.mul(camera.pixel_delta_u, x + rx))
      |> Vec.add(Vec.mul(camera.pixel_delta_v, y + ry))

    # ray_origin = camera.center
    ray_origin =
      if camera.defocus_angle <= 0, do: camera.center, else: defocus_disk_sample(camera)

    ray_direction = Vec.sub(pixel_sample, ray_origin)
    ExRay.ray(ray_origin, ray_direction)
  end

  defp defocus_disk_sample(%__MODULE__{} = camera) do
    {x, y, _z} = Vec.random_in_unit_disk()

    camera.center
    |> Vec.add(Vec.mul(camera.defocus_disk_u, x))
    |> Vec.add(Vec.mul(camera.defocus_disk_v, y))
  end

  defp sample_square do
    ExRay.vector(:rand.uniform() - 0.5, :rand.uniform() - 0.5, 0)
  end
end
