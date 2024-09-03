defmodule ExRay do
  alias ExRay.{Camera, Color, Ray, Sphere, Vec, World}

  def generate do
    camera =
      Camera.new()
      |> then(fn c ->
        %Camera{c | aspect_ratio: 16 / 9, image_width: 400, samples_per_pixel: 100, max_depth: 50}
      end)

    ground_mat = ExRay.Material.Lambertian.new(color(0.8, 0.8, 0.0))
    center_mat = ExRay.Material.Lambertian.new(color(0.1, 0.2, 0.5))
    left_mat = ExRay.Material.Dielectric.new(1.5)
    bubble_mat = ExRay.Material.Dielectric.new(1 / 1.50)
    right_mat = ExRay.Material.Metal.new(color(0.8, 0.6, 0.2), 1)

    world =
      World.new()
      |> World.add(Sphere.new(point(0, -100.5, -1), 100, ground_mat))
      |> World.add(Sphere.new(point(0, 0, -1.2), 0.5, center_mat))
      |> World.add(Sphere.new(point(-1, 0, -1), 0.5, left_mat))
      |> World.add(Sphere.new(point(-1, 0, -1), 0.4, bubble_mat))
      |> World.add(Sphere.new(point(1, 0, -1), 0.5, right_mat))

    Camera.render(camera, world)
  end

  def point(x, y, z), do: Vec.new(x, y, z)
  def vector(x, y, z), do: Vec.new(x, y, z)
  def color(r, g, b), do: Color.new(r, g, b)
  def ray(o, d), do: Ray.new(o, d)
end
