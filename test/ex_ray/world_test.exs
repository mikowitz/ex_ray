defmodule ExRay.WordTest do
  use ExRay.TestCase

  alias ExRay.{Camera, Computations, Intersection, Light, Material, Sphere, Transformation, World}

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
