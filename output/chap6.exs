import ExRay
import ExRay.Transformation

alias ExRay.Material

ray_origin = point(0, 0, -5)
wall_z = 10
wall_size = 7.0

canvas_pixels = 200

pixel_size = wall_size / canvas_pixels

half = wall_size / 2

canvas = ExRay.Canvas.new(canvas_pixels, canvas_pixels)

material = Material.new(color: color(1, 0.2, 1))

shape =
  sphere()
  |> ExRay.Sphere.set_material(material)

light = ExRay.Light.point_light(point(-10, 10, -10), white())

coords = for y <- 0..(canvas_pixels - 1), x <- 0..(canvas_pixels - 1), do: {x, y}

image =
  Enum.reduce(coords, canvas, fn {x, y}, image ->
    world_y = half - pixel_size * y
    world_x = -half + pixel_size * x

    position = point(world_x, world_y, wall_z)

    r = ray(ray_origin, normalize(subtract(position, ray_origin)))
    xs = ExRay.Ray.intersect(r, shape)

    case ExRay.Intersections.hit(xs) do
      nil ->
        image

      hit ->
        point = ExRay.Ray.position(r, hit.t)
        normal = ExRay.Sphere.normal_at(hit.object, point)
        eye = negate(r.direction)

        color = Material.lighting(hit.object.material, light, point, eye, normal)

        ExRay.Canvas.write(image, {x, y}, color)
    end
  end)

ExRay.Canvas.save(image, "output/chap6.png")
