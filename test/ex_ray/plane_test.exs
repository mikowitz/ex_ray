defmodule ExRay.PlaneTest do
  use ExRay.TestCase

  alias ExRay.Plane

  describe "normal_at/2" do
    test "the normal of a plane is constant everywhere" do
      plane = Plane.new()

      assert Plane.normal_at(plane, point(0, 0, 0)) == vector(0, 1, 0)
      assert Plane.normal_at(plane, point(10, 0, -10)) == vector(0, 1, 0)
      assert Plane.normal_at(plane, point(-5, 0, 150)) == vector(0, 1, 0)
    end
  end

  describe "local_intersect/2" do
    test "with a ray parallel to the plane" do
      plane = Plane.new()
      ray = ray(point(0, 10, 0), vector(0, 0, 1))

      assert Plane.local_intersect(plane, ray) == []
    end

    test "with a coplanar ray" do
      plane = Plane.new()
      ray = ray(point(0, 0, 0), vector(0, 0, 1))

      assert Plane.local_intersect(plane, ray) == []
    end

    test "intersecting a plane from above" do
      plane = Plane.new()
      ray = ray(point(0, 1, 0), vector(0, -1, 0))

      [i] = Plane.local_intersect(plane, ray)
      assert i.t == 1
      assert i.object == plane
    end

    test "intersecting a plane from below" do
      plane = Plane.new()
      ray = ray(point(0, -1, 0), vector(0, 1, 0))

      [i] = Plane.local_intersect(plane, ray)
      assert i.t == 1
      assert i.object == plane
    end
  end
end
