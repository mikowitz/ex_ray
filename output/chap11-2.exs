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

wall =
  Plane.new()
  |> Plane.set_material(
    Material.new(
      specular: 0,
      ambient: 0.8,
      diffuse: 0.2,
      pattern: ExRay.Pattern.Checkers.new([color(0.15, 0.15, 0.15), color(0.85, 0.85, 0.85)])
    )
  )
  |> Plane.set_transform(
    translation(0, 0, 10)
    |> rotation_x(pi / 2)
  )

s1 =
  Sphere.new()
  |> Sphere.set_material(
    Material.new(
      color: white(),
      ambient: 0,
      diffuse: 0,
      specular: 0.9,
      shininess: 300,
      reflective: 0.9,
      transparency: 0.9,
      refractive_index: 1.5
    )
  )

s1 = %{s1 | id: "BIG-SPHERE"}

s2 =
  Sphere.new()
  |> Sphere.set_material(
    Material.new(
      color: white(),
      ambient: 0,
      diffuse: 0,
      specular: 0.9,
      shininess: 300,
      reflective: 0.9,
      transparency: 0.9,
      refractive_index: 1.0000034
    )
  )
  |> Sphere.set_transform(scaling(0.5, 0.5, 0.5))

s2 = %{s2 | id: "SMALL-SPHERE"}

world =
  World.new()
  |> World.add_objects([wall, s1, s2])
  |> World.set_light(Light.point_light(point(2, 10, -5), color(0.9, 0.9, 0.9)))

camera =
  Camera.new(300, 300, 0.45)
  |> Camera.set_transform(view_transform(point(0, 0, -5), point(0, 0, 0), vector(0, 1, 0)))

canvas = World.render(world, camera)
Canvas.save(canvas, "output/chap11-2.png")
