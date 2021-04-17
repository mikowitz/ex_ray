import ExRay
import ExRay.Transformation

alias ExRay.{
  Camera,
  Canvas,
  Light,
  Material,
  Pattern.Checkers,
  Pattern.Stripes,
  Plane,
  Sphere,
  World
}

pi = :math.pi()

floor =
  Plane.new()
  |> Plane.set_material(
    Material.new(
      specular: 0,
      reflective: 0.3333,
      pattern: ExRay.Pattern.Checkers.new([black(), white()])
    )
  )

left_wall =
  Plane.new()
  |> Plane.set_transform(
    translation(0, 0, 5)
    |> rotation_y(pi / 4)
    |> rotation_x(pi / 2)
  )

right_wall =
  Plane.new()
  |> Plane.set_transform(
    translation(0, 0, 5)
    |> rotation_y(-pi / 4)
    |> rotation_x(pi / 2)
  )

middle =
  Sphere.new()
  |> Sphere.set_transform(translation(-0.5, 1, 0.5))
  |> Sphere.set_material(
    Material.new(color: color(1, 0.1, 0.2), diffuse: 0.7, specular: 0.3, shininess: 50)
  )

right =
  Sphere.new()
  |> Sphere.set_transform(
    translation(1.5, 0.75, -0.5)
    |> scaling(0.5, 0.5, 0.5)
  )
  |> Sphere.set_material(Material.new(color: color(0.5, 1, 0.1), diffuse: 0.7, specular: 0.3))

left =
  Sphere.new()
  |> Sphere.set_transform(
    translation(-1.5, 0.4, -0.75)
    |> scaling(0.33, 0.33, 0.33)
  )
  |> Sphere.set_material(Material.new(color: color(1, 0.8, 0.1), diffuse: 0.7, specular: 0.3))

world =
  World.new()
  |> World.add_objects([floor, left_wall, right_wall, middle, right, left])
  |> World.set_light(Light.point_light(point(-5, 10, -10), white()))

camera =
  Camera.new(200, 100, pi / 3)
  |> Camera.set_transform(view_transform(point(0, 1.5, -6), point(0, 1, 0), vector(0, 1, 0)))

canvas = World.render(world, camera)
Canvas.save(canvas, "output/chap11.png")
