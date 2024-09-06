defmodule ExRay do
  alias ExRay.{Camera, Color, Ray, Sphere, Utils, Vec, World}

  def generate do
    camera =
      Camera.new()
      |> then(fn c ->
        %Camera{
          c
          | aspect_ratio: 16 / 9,
            image_width: 1200,
            samples_per_pixel: 500,
            max_depth: 50,
            vfov: 20,
            lookfrom: point(13, 2, 3),
            lookat: point(0, 0, 0),
            vup: vector(0, 1, 0),
            defocus_angle: 0.6,
            focus_dist: 10.0
        }
      end)

    ground_mat = ExRay.Material.Lambertian.new(color(0.6, 0.6, 0.5))

    world =
      World.new()
      |> World.add(Sphere.new(point(0, -1000, 0), 1000, ground_mat))
      |> World.add(Sphere.new(point(0, 1, 0), 1, ExRay.Material.Dielectric.new(1.5)))
      |> World.add(
        Sphere.new(point(-4, 1, 0), 1, ExRay.Material.Lambertian.new(color(0.4, 0.2, 0.1)))
      )
      |> World.add(
        Sphere.new(point(4, 1, 0), 1, ExRay.Material.Metal.new(color(0.7, 0.6, 0.5), 0.0))
      )

    coords = for a <- -11..10, b <- -11..10, do: {a, b}

    world =
      Enum.reduce(coords, world, fn {a, b}, w ->
        center = point(a + 0.9 * :rand.uniform(), 0.2, b + 0.9 * :rand.uniform())

        if Vec.length(Vec.sub(center, point(4, 0.2, 0))) > 0.9 do
          material =
            case :rand.uniform() do
              n when n < 0.8 ->
                albedo = Color.random() |> Color.mul(Color.random())
                ExRay.Material.Lambertian.new(albedo)

              n when n < 0.95 ->
                albedo = Color.random(0.5, 1)
                fuzz = Utils.random(0, 0.5)
                ExRay.Material.Metal.new(albedo, fuzz)

              _ ->
                ExRay.Material.Dielectric.new(1.5)
            end

          World.add(w, Sphere.new(center, 0.2, material))
        else
          w
        end
      end)

    Camera.prender(camera, world)
  end

  def point(x, y, z), do: Vec.new(x, y, z)
  def vector(x, y, z), do: Vec.new(x, y, z)
  def color(r, g, b), do: Color.new(r, g, b)
  def ray(o, d), do: Ray.new(o, d)
end
