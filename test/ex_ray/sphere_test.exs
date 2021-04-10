defmodule ExRay.SphereTest do
  use ExUnit.Case, async: true
  use EqualityHelper

  alias ExRay.Sphere

  import ExRay
  import ExRay.Transformation

  describe "new/0" do
    test "creates a sphere with a default transform of the identity matrix" do
      s = sphere()

      assert s.transform == ExRay.Matrix.identity()
    end

    test "creates a sphere with a default material" do
      s = sphere()

      assert s.material == ExRay.Material.new()
    end
  end

  describe "set_material/2" do
    test "updates the material for a sphere" do
      s = sphere()

      m = ExRay.Material.new(ambient: 1)

      s = Sphere.set_material(s, m)

      assert s.material == m
    end
  end

  describe "set_transform/2" do
    test "updates sthe transform for a sphere" do
      s = sphere()
      t = translation(2, 3, 4)

      s = Sphere.set_transform(s, t)

      assert s.transform == t
    end
  end

  describe "normal_at/2" do
    test "at a point on the x axis" do
      s = sphere()
      n = Sphere.normal_at(s, point(1, 0, 0))

      assert n == vector(1, 0, 0)
    end

    test "at a point on the y axis" do
      s = sphere()
      n = Sphere.normal_at(s, point(0, 1, 0))

      assert n == vector(0, 1, 0)
    end

    test "at a point on the z axis" do
      s = sphere()
      n = Sphere.normal_at(s, point(0, 0, 1))

      assert n == vector(0, 0, 1)
    end

    @sqrt3_over3 :math.sqrt(3) / 3
    @sqrt2_over2 :math.sqrt(2) / 2

    test "at a non-axial point" do
      s = sphere()
      n = Sphere.normal_at(s, point(@sqrt3_over3, @sqrt3_over3, @sqrt3_over3))

      assert n == vector(@sqrt3_over3, @sqrt3_over3, @sqrt3_over3)
    end

    test "the normal is a normalized vector" do
      s = sphere()
      n = Sphere.normal_at(s, point(@sqrt3_over3, @sqrt3_over3, @sqrt3_over3))

      assert n == normalize(n)
    end

    test "on a translated sphere" do
      s =
        sphere()
        |> Sphere.set_transform(translation(0, 1, 0))

      n = Sphere.normal_at(s, point(0, 1.70711, -0.70711))

      assert n == vector(0, 0.70711, -0.70711)
    end

    test "on a transformed sphere" do
      s =
        sphere()
        |> Sphere.set_transform(
          scaling(1, 0.5, 1)
          |> rotation_z(:math.pi() / 5)
        )

      n = Sphere.normal_at(s, point(0, @sqrt2_over2, -@sqrt2_over2))

      assert n == vector(0, 0.97014, -0.24254)
    end
  end
end
