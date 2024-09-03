defmodule ExRay.Camera do
  alias ExRay.{Color, HitRecord, Interval, Ray, Vec}

  defstruct [
    :image_height,
    :center,
    :pixel00_loc,
    :pixel_delta_u,
    :pixel_delta_v,
    :pixels_sample_scale,
    aspect_ratio: 1,
    image_width: 100,
    samples_per_pixel: 10,
    max_depth: 10
  ]

  def new, do: %__MODULE__{}

  def render(%__MODULE__{} = camera, world) do
    %__MODULE__{
      image_width: image_width,
      image_height: image_height,
      samples_per_pixel: samples_per_pixel
    } = camera = initialize(camera)

    File.open("test.ppm", [:write], fn file ->
      IO.puts(file, "P3\n#{image_width} #{image_height}\n255")

      for y <- 0..(image_height - 1) do
        for x <- 0..(image_width - 1) do
          color =
            Enum.reduce(1..samples_per_pixel, Color.black(), fn _, c ->
              ray = get_ray(camera, x, y)
              Color.add(c, ray_color(ray, camera.max_depth, world))
            end)
            |> Color.mul(camera.pixels_sample_scale)

          IO.puts(file, Color.to_ppm(color))
        end
      end
    end)

    IO.puts("")
  end

  defp initialize(%__MODULE__{image_width: image_width, aspect_ratio: aspect_ratio} = camera) do
    image_height = max(round(image_width / aspect_ratio), 1)

    focal_length = 1
    viewport_height = 2
    viewpoint_width = viewport_height * (image_width / image_height)
    camera_center = ExRay.point(0, 0, 0)

    viewport_u = ExRay.vector(viewpoint_width, 0, 0)
    viewport_v = ExRay.vector(0, -viewport_height, 0)

    pixel_delta_u = Vec.div(viewport_u, image_width)
    pixel_delta_v = Vec.div(viewport_v, image_height)

    viewport_upper_left =
      Vec.sub(camera_center, ExRay.vector(0, 0, focal_length))
      |> Vec.sub(Vec.div(viewport_u, 2))
      |> Vec.sub(Vec.div(viewport_v, 2))

    pixel00_loc =
      viewport_upper_left
      |> Vec.add(Vec.mul(Vec.add(pixel_delta_u, pixel_delta_v), 0.5))

    %__MODULE__{
      camera
      | image_height: image_height,
        center: camera_center,
        pixel00_loc: pixel00_loc,
        pixel_delta_u: pixel_delta_u,
        pixel_delta_v: pixel_delta_v,
        pixels_sample_scale: 1 / camera.samples_per_pixel
    }
  end

  defp ray_color(ray, depth, world) do
    if depth <= 0 do
      Color.black()
    else
      case ExRay.Hittable.hit(world, ray, Interval.new(0.001, 1.0e100)) do
        %HitRecord{} = hr ->
          direction = Vec.add(hr.normal, Vec.random_unit_vector())
          Color.mul(ray_color(Ray.new(hr.point, direction), depth - 1, world), 0.5)

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

    ray_origin = camera.center
    ray_direction = Vec.sub(pixel_sample, ray_origin)
    ExRay.ray(ray_origin, ray_direction)
  end

  defp sample_square do
    ExRay.vector(:rand.uniform() - 0.5, :rand.uniform() - 0.5, 0)
  end
end
