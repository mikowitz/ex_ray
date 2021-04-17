defmodule ExRay.ComputationsTest do
  use ExRay.TestCase

  alias ExRay.{Computations, Intersection, Material, Plane, Sphere, Transformation}

  describe "new/2" do
    test "prepares computations from a ray and an intersection" do
      ray = ray(point(0, 0, -5), vector(0, 0, 1))
      shape = Sphere.new()
      i = Intersection.new(4, shape)

      comps = Computations.new(i, ray)

      assert comps.t == 4
      assert comps.object == shape
      assert comps.point == point(0, 0, -1)
      assert comps.eyev == vector(0, 0, -1)
      assert comps.normalv == vector(0, 0, -1)
      refute comps.inside
    end

    test "when the intersection occurs on the inside of the shape" do
      ray = ray(point(0, 0, 0), vector(0, 0, 1))
      shape = Sphere.new()
      i = Intersection.new(1, shape)

      comps = Computations.new(i, ray)

      assert comps.t == 1
      assert comps.object == shape
      assert comps.point == point(0, 0, 1)
      assert comps.eyev == vector(0, 0, -1)
      assert comps.normalv == vector(0, 0, -1)
      assert comps.inside
    end

    test "calculates the over_point" do
      ray = ray(point(0, 0, -5), vector(0, 0, 1))

      shape =
        Sphere.new()
        |> Sphere.set_transform(Transformation.translation(0, 0, 1))

      i = Intersection.new(5, shape)
      comps = Computations.new(i, ray)

      [_, _, z, _] = comps.point
      [_, _, oz, _] = comps.over_point

      assert oz < -epsilon() / 2
      assert z > oz
    end

    test "calculates the under_point" do
      ray = ray(point(0, 0, -5), vector(0, 0, 1))

      shape =
        Sphere.new()
        |> Sphere.set_material(Material.glass())
        |> Sphere.set_transform(Transformation.translation(0, 0, 1))

      i = Intersection.new(5, shape)
      comps = Computations.new(i, ray, [i])

      [_, _, z, _] = comps.point
      [_, _, uz, _] = comps.under_point

      assert uz > epsilon() / 2
      assert z < uz
    end

    test "precomputes the reflection vector" do
      shape = Plane.new()

      ray = ray(point(0, 1, -1), vector(0, -@root2 / 2, @root2 / 2))
      i = Intersection.new(@root2, shape)

      comps = Computations.new(i, ray)

      assert comps.reflectv == vector(0, @root2 / 2, @root2 / 2)
    end
  end

  describe "finding n1 and n2 for refractive intersections" do
    setup :with_glass_spheres

    @results [
      {0, 1.0, 1.5},
      {1, 1.5, 2.0},
      {2, 2.0, 2.5},
      {3, 2.5, 2.5},
      {4, 2.5, 1.5},
      {5, 1.5, 1.0}
    ]

    for {i, n1, n2} <- @results do
      @i i
      @n1 n1
      @n2 n2
      test "for intersection at index #{@i}", %{xs: xs} do
        ray = ray(point(0, 0, -4), vector(0, 0, 1))
        comps = Computations.new(Enum.at(xs, @i), ray, xs)

        assert comps.n1 == @n1
        assert comps.n2 == @n2
      end
    end
  end

  def with_glass_spheres(_) do
    a =
      Sphere.new()
      |> Sphere.set_material(Material.glass(refractive_index: 1.5))
      |> Sphere.set_transform(Transformation.scaling(2, 2, 2))

    b =
      Sphere.new()
      |> Sphere.set_material(Material.glass(refractive_index: 2))
      |> Sphere.set_transform(Transformation.translation(0, 0, -0.25))

    c =
      Sphere.new()
      |> Sphere.set_material(Material.glass(refractive_index: 2.5))
      |> Sphere.set_transform(Transformation.translation(0, 0, 0.25))

    xs = [
      Intersection.new(2, a),
      Intersection.new(2.75, b),
      Intersection.new(3.25, c),
      Intersection.new(4.75, b),
      Intersection.new(5.25, c),
      Intersection.new(6, a)
    ]

    {:ok, xs: xs}
  end
end
