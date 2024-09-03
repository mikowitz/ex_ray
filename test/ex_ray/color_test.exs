defmodule ExRay.ColorTest do
  use ExUnit.Case, async: true

  use ExRay.Test.Support.Comparison

  alias ExRay.Color

  describe "Color.new/1" do
    test "returns a new color" do
      c = Color.new(0.5, 0.2, 0.1)

      assert c == {0.5, 0.2, 0.1}
    end
  end

  describe "Color.add/2" do
    test "returns the sum of two colors" do
      c = Color.new(0.5, 0.2, 0.1)
      d = Color.new(0.2, 0.4, 0.3)

      assert Color.add(c, d) == {0.7, 0.6, 0.4}
    end

    test "color addition is commutative" do
      c = Color.new(0.5, 0.2, 0.1)
      d = Color.new(0.2, 0.4, 0.3)

      assert Color.add(c, d) == Color.add(d, c)
    end
  end

  describe "Color.mul/2" do
    test "returns a color multiplied by a scalar" do
      c = Color.new(0.5, 0.2, 0.1)

      assert Color.mul(c, 2) == {1, 0.4, 0.2}
    end
  end

  describe "Color.to_ppm/1" do
    test "returns a PPM string representation of the color" do
      c = Color.new(1.0, 0, 0.5)

      assert Color.to_ppm(c) == "255 0 128"
    end
  end
end
