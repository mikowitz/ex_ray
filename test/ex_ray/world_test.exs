defmodule ExRay.WordTest do
  use ExRay.TestCase

  alias ExRay.{
    Camera,
    Computations,
    Intersection,
    Light,
    Material,
    Plane,
    Sphere,
    Transformation,
    World
  }

  @root2 :math.sqrt(2)

  describe "new/0" do
    test "creates an empty world" do
      w = World.new()

      refute w.light_source
      assert w.objects == []
    end
  end

  test "intersect a world with a ray" do
    world = default_world()
    ray = ray(point(0, 0, -5), vector(0, 0, 1))

    [a, b, c, d] = World.intersect(world, ray)

    assert a.t == 4
    assert b.t == 4.5
    assert c.t == 5.5
    assert d.t == 6
  end

  describe "shade_hit/2" do
    setup :with_default_world

    test "shading an intersection", %{world: world} do
      ray = ray(point(0, 0, -5), vector(0, 0, 1))
      [s1 | _] = world.objects
      i = Intersection.new(4, s1)
      comps = Computations.new(i, ray)

      assert World.shade_hit(world, comps) == color(0.38066, 0.47583, 0.2855)
    end

    test "shading an intersection from the inside", %{world: world} do
      world =
        world
        |> World.set_light(Light.point_light(point(0, 0.25, 0), white()))

      ray = ray(point(0, 0, 0), vector(0, 0, 1))
      [_, s2] = world.objects
      i = Intersection.new(0.5, s2)
      comps = Computations.new(i, ray)

      assert World.shade_hit(world, comps) == color(0.90498, 0.90498, 0.90498)
    end

    test "shading an intersection in shadow" do
      w =
        World.new()
        |> World.set_light(Light.point_light(point(0, 0, -10), white()))

      s1 = Sphere.new()

      s2 =
        Sphere.new()
        |> Sphere.set_transform(Transformation.translation(0, 0, 10))

      w = World.add_objects(w, [s1, s2])

      r = ray(point(0, 0, 5), vector(0, 0, 1))
      i = Intersection.new(4, s2)
      comps = Computations.new(i, r)

      assert World.shade_hit(w, comps) == color(0.1, 0.1, 0.1)
    end

    test "with a reflective material", %{world: world} do
      shape =
        Plane.new()
        |> Plane.set_material(Material.new(reflective: 0.5))
        |> Plane.set_transform(Transformation.translation(0, -1, 0))

      world = World.add_objects(world, [shape])

      ray = ray(point(0, 0, -3), vector(0, -@root2 / 2, @root2 / 2))
      i = Intersection.new(@root2, shape)

      comps = Computations.new(i, ray)

      assert World.shade_hit(world, comps) == color(0.87677, 0.92436, 0.82918)
    end

    test "with a transparent material", %{world: world} do
      floor =
        Plane.new()
        |> Plane.set_material(
          Material.new(
            transparency: 0.5,
            refractive_index: 1.5
          )
        )
        |> Plane.set_transform(Transformation.translation(0, -1, 0))

      ball =
        Sphere.new()
        |> Sphere.set_material(
          Material.new(
            color: color(1, 0, 0),
            ambient: 0.5
          )
        )
        |> Sphere.set_transform(Transformation.translation(0, -3.5, -0.5))

      world = World.add_objects(world, [floor, ball])

      ray = ray(point(0, 0, -3), vector(0, -@root2 / 2, @root2 / 2))

      [i] =
        xs = [
          Intersection.new(@root2, floor)
        ]

      comps = Computations.new(i, ray, xs)
      assert World.shade_hit(world, comps) == color(0.93642, 0.68642, 0.68642)
    end
  end

  describe "color_at/2" do
    setup :with_default_world

    test "the color when a ray misses", %{world: world} do
      ray = ray(point(0, 0, -5), vector(0, 1, 0))

      assert World.color_at(world, ray) == black()
    end

    test "the color when a ray hits", %{world: world} do
      ray = ray(point(0, 0, -5), vector(0, 0, 1))

      assert World.color_at(world, ray) == color(0.38066, 0.47583, 0.2855)
    end

    test "with an intersection behind the ray", %{world: world} do
      [s1, s2] = world.objects

      outer_material = %{s1.material | ambient: 1}
      s1 = %{s1 | material: outer_material}

      inner_material = %{s2.material | ambient: 1}
      s2 = %{s2 | material: inner_material}

      world = %{world | objects: [s1, s2]}

      ray = ray(point(0, 0, 0.75), vector(0, 0, -1))

      assert World.color_at(world, ray) == inner_material.color
    end

    test "with mutually reflective surfaces" do
      world =
        World.new()
        |> World.set_light(Light.point_light(origin(), white()))

      lower =
        Plane.new()
        |> Plane.set_material(Material.new(reflective: 1))
        |> Plane.set_transform(Transformation.translation(0, -1, 0))

      upper =
        Plane.new()
        |> Plane.set_material(Material.new(reflective: 1))
        |> Plane.set_transform(Transformation.translation(0, 1, 0))

      world = World.add_objects(world, [lower, upper])
      ray = ray(origin(), vector(0, 1, 0))

      assert World.color_at(world, ray) == color(9.5, 9.5, 9.5)
    end
  end

  describe "rendering a world with a camera" do
    setup :with_default_world

    test "writes to a canvas", %{world: world} do
      c = Camera.new(11, 11, :math.pi() / 2)
      from = point(0, 0, -5)
      to = point(0, 0, 0)
      up = vector(0, 1, 0)

      view_transform = Transformation.view_transform(from, to, up)
      c = %{c | transform: view_transform}

      image = World.render(world, c)

      assert ExRay.Canvas.at(image, 5, 5) == color(0.38039, 0.47451, 0.28627)
    end
  end

  describe "is_shadowed/2" do
    setup :with_default_world

    test "there is no shadow when nothing is collinear with the point and light", %{world: world} do
      point = point(0, 10, 0)

      refute World.is_shadowed(world, point)
    end

    test "there is a shadow when an object is between the point and the light", %{world: world} do
      point = point(10, -10, 10)

      assert World.is_shadowed(world, point)
    end

    test "there is no shadow when an object is behind the light", %{world: world} do
      point = point(-20, 20, -20)

      refute World.is_shadowed(world, point)
    end

    test "there is no shadow when an object is behind the point", %{world: world} do
      point = point(-2, 2, -2)

      refute World.is_shadowed(world, point)
    end
  end

  describe "reflected_color/2" do
    setup :with_default_world

    test "is black for a non-reflective material", %{world: world} do
      ray = ray(origin(), vector(0, 0, 1))
      [s1, s2] = world.objects

      s2 = Sphere.set_material(s2, %{s2.material | ambient: 1})

      world = %{world | objects: [s1, s2]}

      i = Intersection.new(1, s2)

      comps = Computations.new(i, ray)

      assert World.reflected_color(world, comps) == black()
    end

    test "for a reflective material", %{world: world} do
      shape =
        Plane.new()
        |> Plane.set_material(Material.new(reflective: 0.5))
        |> Plane.set_transform(Transformation.translation(0, -1, 0))

      world = World.add_objects(world, [shape])

      ray = ray(point(0, 0, -3), vector(0, -@root2 / 2, @root2 / 2))
      i = Intersection.new(@root2, shape)

      comps = Computations.new(i, ray)

      assert World.reflected_color(world, comps) == color(0.19032, 0.2379, 0.14274)
    end

    test "at maximum recursive depth", %{world: world} do
      shape =
        Plane.new()
        |> Plane.set_material(Material.new(reflective: 0.5))
        |> Plane.set_transform(Transformation.translation(0, -1, 0))

      world = World.add_objects(world, [shape])
      ray = ray(point(0, 0, -3), vector(0, -@root2 / 2, @root2 / 2))
      i = Intersection.new(@root2, shape)

      comps = Computations.new(i, ray)

      assert World.reflected_color(world, comps, 0) == black()
    end
  end

  describe "refracted_color/2" do
    setup :with_default_world

    test "with an opaque surface", %{world: world} do
      [s1, _] = world.objects

      ray = ray(point(0, 0, -5), vector(0, 0, 1))

      [i, _] =
        xs = [
          Intersection.new(4, s1),
          Intersection.new(6, s1)
        ]

      comps = Computations.new(i, ray, xs)

      assert World.refracted_color(world, comps) == black()
    end

    test "at maximum recursive depth", %{world: world} do
      [s1, s2] = world.objects
      s1 = Sphere.set_material(s1, Material.new(transparency: 1, refractive_index: 1.5))

      world = %{world | objects: [s1, s2]}

      ray = ray(point(0, 0, -5), vector(0, 0, 1))

      [i, _] =
        xs = [
          Intersection.new(4, s1),
          Intersection.new(6, s1)
        ]

      comps = Computations.new(i, ray, xs)

      assert World.refracted_color(world, comps, 0) == black()
    end

    test "under total internal reflection", %{world: world} do
      [s1, s2] = world.objects
      s1 = Sphere.set_material(s1, Material.new(transparency: 1, refractive_index: 1.5))

      world = %{world | objects: [s1, s2]}

      ray = ray(point(0, 0, @root2 / 2), vector(0, 1, 0))

      [_, i] =
        xs = [
          Intersection.new(-@root2 / 2, s1),
          Intersection.new(@root2 / 2, s1)
        ]

      comps = Computations.new(i, ray, xs)

      assert World.refracted_color(world, comps) == black()
    end

    test "with a refracted ray", %{world: world} do
      [s1, s2] = world.objects

      s1 =
        Sphere.set_material(
          s1,
          Material.new(ambient: 1, pattern: ExRay.Test.TestPattern.new([white(), black()]))
        )

      s2 =
        Sphere.set_material(
          s2,
          Material.new(transparency: 1, refractive_index: 1.5)
        )

      world = %{world | objects: [s1, s2]}

      ray = ray(point(0, 0, 0.1), vector(0, 1, 0))

      [_, _, i, _] =
        xs = [
          Intersection.new(-0.9899, s1),
          Intersection.new(-0.4899, s2),
          Intersection.new(0.4899, s2),
          Intersection.new(0.9899, s1)
        ]

      comps = Computations.new(i, ray, xs)

      assert World.refracted_color(world, comps) == color(0, 0.99888, 0.04725)
    end
  end

  def with_default_world(_context) do
    {:ok, world: default_world()}
  end

  defp default_world do
    world = World.new()

    material = Material.new(color: color(0.8, 1, 0.6), diffuse: 0.7, specular: 0.2)
    transformation = Transformation.scaling(0.5, 0.5, 0.5)

    s1 =
      Sphere.new()
      |> Sphere.set_material(material)

    s2 =
      Sphere.new()
      |> Sphere.set_transform(transformation)

    light = Light.point_light(point(-10, 10, -10), white())

    world
    |> World.add_objects([s1, s2])
    |> World.set_light(light)
  end
end
