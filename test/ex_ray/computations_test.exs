defmodule ExRay.ComputationsTest do
  use ExRay.TestCase

  alias ExRay.{Computations, Intersection, Sphere}

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
  end
end
