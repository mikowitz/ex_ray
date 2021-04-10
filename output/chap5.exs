import ExRay
import ExRay.Transformation
ray_origin = point(0, 0, -5)
wall_z = 10
wall_size = 7.0

canvas_pixels = 100

pixel_size = wall_size / canvas_pixels

half = wall_size / 2

# canvas = ExPng.Image.new(canvas_pixels, canvas_pixels)
canvas = ExRay.Canvas.new(canvas_pixels, canvas_pixels)

color = color(0, 0, 1)

shape =
  sphere()
  |> ExRay.Sphere.set_transform(
    shearing(1, 0, 0, 0, 0, 0)
    |> scaling(1, 0.5, 1)
  )

coords = for y <- 0..(canvas_pixels - 1), x <- 0..(canvas_pixels - 1), do: {x, y}

image =
  Enum.reduce(coords, canvas, fn {x, y}, image ->
    world_y = half - pixel_size * y
    world_x = -half + pixel_size * x

    position = point(world_x, world_y, wall_z)

    r = ray(ray_origin, normalize(subtract(position, ray_origin)))
    xs = ExRay.Ray.intersect(r, shape)

    case ExRay.Intersections.hit(xs) do
      nil -> image
      _ -> ExRay.Canvas.write(image, {x, y}, color)
    end
  end)

ExRay.Canvas.save(image, "output/chap5.png")
