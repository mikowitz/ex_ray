defmodule ExRay.RayTest do
  use ExUnit.Case, async: true
  use EqualityHelper

  alias ExRay.{Ray, Sphere}
  import ExRay
  import ExRay.Transformation

  describe "new/2" do
    test "creates a queryable ray" do
      ray = ray(point(1, 2, 3), vector(4, 5, 6))

      assert ray.origin == point(1, 2, 3)
      assert ray.direction == vector(4, 5, 6)
    end
  end

  describe "position/2" do
    test "calculates the point at position t along the ray" do
      ray = ray(point(2, 3, 4), vector(1, 0, 0))

      Ray.position(ray, 0) == point(2, 3, 4)
      Ray.position(ray, 1) == point(3, 3, 4)
      Ray.position(ray, -1) == point(1, 3, 4)
      Ray.position(ray, 2.5) == point(4.5, 3, 4)
    end
  end

  describe "intersect/2" do
    test "a ray through the origin intersects a unit sphere at 2 points" do
      ray = ray(point(0, 0, -5), vector(0, 0, 1))
      sphere = sphere()

      [i1, i2] = Ray.intersect(ray, sphere)

      assert i1.t == 4.0
      assert i1.object == sphere

      assert i2.t == 6.0
      assert i2.object == sphere
    end

    test "a raised ray intersects a unit sphere at a tangent" do
      ray = ray(point(0, 1, -5), vector(0, 0, 1))
      sphere = sphere()

      [i1, i2] = Ray.intersect(ray, sphere)

      assert i1.t == 5.0
      assert i1.object == sphere

      assert i2.t == 5.0
      assert i2.object == sphere
    end

    test "a ray misses a sphere" do
      ray = ray(point(0, 2, -5), vector(0, 0, 1))
      sphere = sphere()

      xs = Ray.intersect(ray, sphere)

      assert xs == []
    end

    test "a ray originates inside a sphere" do
      ray = ray(point(0, 0, 0), vector(0, 0, 1))
      sphere = sphere()

      [i1, i2] = Ray.intersect(ray, sphere)

      assert i1.t == -1.0
      assert i1.object == sphere

      assert i2.t == 1.0
      assert i2.object == sphere
    end

    test "a sphere is behind a ray" do
      ray = ray(point(0, 0, 5), vector(0, 0, 1))
      sphere = sphere()

      [i1, i2] = Ray.intersect(ray, sphere)

      assert i1.t == -6.0
      assert i1.object == sphere

      assert i2.t == -4.0
      assert i2.object == sphere
    end

    test "intersecting a scaled sphere" do
      ray = ray(point(0, 0, -5), vector(0, 0, 1))

      sphere =
        sphere()
        |> Sphere.set_transform(scaling(2, 2, 2))

      [i1, i2] = Ray.intersect(ray, sphere)

      assert i1.t == 3.0
      assert i1.object == sphere

      assert i2.t == 7.0
      assert i2.object == sphere
    end

    test "intersecting a translated sphere" do
      ray = ray(point(0, 0, -5), vector(0, 0, 1))

      sphere =
        sphere()
        |> Sphere.set_transform(translation(5, 0, 0))

      assert Ray.intersect(ray, sphere) == []
    end
  end

  describe "transform/2" do
    test "translating a ray" do
      r = ray(point(1, 2, 3), vector(0, 1, 0))
      m = translation(3, 4, 5)

      r2 = Ray.transform(r, m)

      assert r2.origin == point(4, 6, 8)
      assert r2.direction == vector(0, 1, 0)
    end

    test "scaling a ray" do
      r = ray(point(1, 2, 3), vector(0, 1, 0))
      m = scaling(2, 3, 4)

      r2 = Ray.transform(r, m)

      assert r2.origin == point(2, 6, 12)
      assert r2.direction == vector(0, 3, 0)
    end
  end
end
