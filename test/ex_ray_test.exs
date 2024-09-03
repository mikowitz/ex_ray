defmodule ExRayTest do
  use ExUnit.Case
  doctest ExRay

  describe "helper functions" do
    test "point/3 returns a 3-tuple" do
      assert ExRay.point(1, 2, 3) == {1, 2, 3}
    end

    test "vector/3 returns a 3-tuple" do
      assert ExRay.vector(1, 2, 3) == {1, 2, 3}
    end

    test "color/3 returns a 3-tuple" do
      assert ExRay.color(0.5, 0, 0.8) == {0.5, 0, 0.8}
    end
  end
end
