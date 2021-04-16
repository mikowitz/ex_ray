import ExRay
import ExRay.Transformation

alias ExRay.{Camera, Canvas, Light, Material, Sphere, World}

pi = :math.pi()

right_wall =
  Sphere.new()
  |> Sphere.set_transform(
    translation(0, 0, 5)
    |> rotation_y(pi / 4)
    |> rotation_x(pi / 2)
    |> scaling(100, 0.01, 100)
  )
  |> Sphere.set_material(Material.new(color: color(1, 0.9, 0.9), specular: 0))

middle =
  Sphere.new()
  |> Sphere.set_transform(translation(-0.5, 1, -1.5) |> scaling(0.5, 0.5, 0.5))
  |> Sphere.set_material(Material.new(color: color(0.1, 1, 0.5), diffuse: 0.7, specular: 0.3))

near =
  Sphere.new()
  |> Sphere.set_transform(translation(2, 1, 2) |> scaling(0.5, 0.5, 0.5))
  |> Sphere.set_material(Material.new(color: color(1, 0.5, 1.7), diffuse: 0.7, specular: 0.3))

world =
  World.new()
  |> World.add_objects([right_wall, near, middle])
  |> World.set_light(Light.point_light(point(-10, 0, -10), white()))

camera =
  Camera.new(500, 250, pi / 3)
  |> Camera.set_transform(view_transform(point(0, 1.5, -5), point(0, 1, 0), vector(0, 1, 0)))

canvas = World.render(world, camera)
Canvas.save(canvas, "output/chap8-2.png")
