defmodule ExRay.IntersectionsTest do
  use ExUnit.Case, async: true

  alias ExRay.{Intersection, Intersections}

  import ExRay

  describe "hit/1" do
    test "when all intersections have positive t" do
      s = sphere()
      xs = [1, 2] |> Enum.map(&Intersection.new(&1, s))

      hit = Intersections.hit(xs)

      assert hit.t == 1
    end

    test "when some intersections have negative t" do
      s = sphere()
      xs = [-1, 1] |> Enum.map(&Intersection.new(&1, s))

      hit = Intersections.hit(xs)

      assert hit.t == 1
    end

    test "when all intersections have negative t" do
      s = sphere()
      xs = [-2, -1] |> Enum.map(&Intersection.new(&1, s))

      hit = Intersections.hit(xs)

      refute hit
    end

    test "the hit is always the lowest nonnegative intersection" do
      s = sphere()
      xs = [5, 7, -3, 2] |> Enum.map(&Intersection.new(&1, s))

      hit = Intersections.hit(xs)

      assert hit.t == 2
    end
  end
end
