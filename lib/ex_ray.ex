defmodule ExRay do
  alias ExRay.{Color, Ray, Vec}

  def generate do
    aspect_ratio = 16 / 9
    image_width = 400

    image_height = max(round(image_width / aspect_ratio), 1)

    focal_length = 1
    viewport_height = 2
    viewpoint_width = viewport_height * (image_width / image_height)
    camera_center = point(0, 0, 0)

    viewport_u = vector(viewpoint_width, 0, 0)
    viewport_v = vector(0, -viewport_height, 0)

    pixel_delta_u = Vec.div(viewport_u, image_width)
    pixel_delta_v = Vec.div(viewport_v, image_height)

    viewport_upper_left =
      Vec.sub(camera_center, vector(0, 0, focal_length))
      |> Vec.sub(Vec.div(viewport_u, 2))
      |> Vec.sub(Vec.div(viewport_v, 2))

    pixel00_loc =
      viewport_upper_left
      |> Vec.add(Vec.mul(Vec.add(pixel_delta_u, pixel_delta_v), 0.5))

    File.open("test.ppm", [:write], fn file ->
      IO.puts(file, "P3\n#{image_width} #{image_height}\n255")

      for y <- 0..(image_height - 1) do
        for x <- 0..(image_width - 1) do
          pixel_center =
            pixel00_loc
            |> Vec.add(Vec.mul(pixel_delta_u, x))
            |> Vec.add(Vec.mul(pixel_delta_v, y))

          ray_direction = Vec.sub(pixel_center, camera_center)

          ray = ray(camera_center, ray_direction)

          color = ray_color(ray)

          IO.puts(file, Color.to_ppm(color))

          ProgressBar.render(
            y * image_width + x,
            image_width * image_height,
            progress_bar_format()
          )
        end
      end
    end)

    IO.puts("")
  end

  defp ray_color(ray) do
    {_ux, uy, _uz} = Vec.unit_vector(ray.direction)
    a = 0.5 * (uy + 1.0)

    Color.white()
    |> Color.mul(1.0 - a)
    |> Color.add(Color.mul(color(0.5, 0.7, 1.0), a))
  end

  def point(x, y, z), do: Vec.new(x, y, z)
  def vector(x, y, z), do: Vec.new(x, y, z)
  def color(r, g, b), do: Color.new(r, g, b)
  def ray(o, d), do: Ray.new(o, d)

  defp progress_bar_format do
    [
      bar_color: [IO.ANSI.green_background()],
      blank_color: [IO.ANSI.red_background()],
      bar: " ",
      blank: " ",
      left: "",
      right: "",
      width: 50
    ]
  end
end
