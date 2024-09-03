defmodule ExRay.RayTest do
  use ExUnit.Case, async: true

  alias ExRay.Ray

  describe "Ray.new/2" do
    test "returns a ray with the specified origin and direction" do
      origin = ExRay.point(1, 2, 3)
      direction = ExRay.vector(1, 0, 0)

      ray = Ray.new(origin, direction)

      assert ray.origin == origin
      assert ray.direction == direction
    end
  end

  describe "Ray.at/2" do
    test "returns the point along the ray at a given time" do
      origin = ExRay.point(1, 2, 3)
      direction = ExRay.vector(1, 0, 0)

      ray = Ray.new(origin, direction)

      assert Ray.at(ray, 0) == ExRay.point(1, 2, 3)
      assert Ray.at(ray, 2.5) == ExRay.point(3.5, 2, 3)
    end
  end
end
