defmodule ExRay do
  alias ExRay.{Camera, Color, Ray, Sphere, Vec, World}

  def generate do
    camera =
      Camera.new()
      |> then(fn c ->
        %Camera{c | aspect_ratio: 16 / 9, image_width: 400, samples_per_pixel: 100, max_depth: 50}
      end)

    world =
      World.new()
      |> World.add(Sphere.new(point(0, 0, -1), 0.5))
      |> World.add(Sphere.new(point(0, -100.5, -1), 100))

    Camera.render(camera, world)
  end

  def point(x, y, z), do: Vec.new(x, y, z)
  def vector(x, y, z), do: Vec.new(x, y, z)
  def color(r, g, b), do: Color.new(r, g, b)
  def ray(o, d), do: Ray.new(o, d)
end
