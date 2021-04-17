defmodule ExRay.Pattern.GradientTest do
  use ExRay.TestCase

  alias ExRay.Pattern.Gradient

  describe "at/2" do
    test "gradient is constant in y" do
      pattern = Gradient.new([white(), black()])

      assert Gradient.at(pattern, point(0, 0, 0)) == white()
      assert Gradient.at(pattern, point(0, 0.25, 0)) == white()
      assert Gradient.at(pattern, point(0, 0.5, 0)) == white()
      assert Gradient.at(pattern, point(0, 0.75, 0)) == white()
    end

    test "gradient is constant in z" do
      pattern = Gradient.new([white(), black()])

      assert Gradient.at(pattern, point(0, 0, 0)) == white()
      assert Gradient.at(pattern, point(0, 0, 0.25)) == white()
      assert Gradient.at(pattern, point(0, 0, 0.5)) == white()
      assert Gradient.at(pattern, point(0, 0, 0.75)) == white()
    end

    test "interpolates linearly between colors in x" do
      pattern = Gradient.new([white(), black()])

      assert Gradient.at(pattern, point(0, 0, 0)) == white()
      assert Gradient.at(pattern, point(0.25, 0, 0)) == color(0.75, 0.75, 0.75)
      assert Gradient.at(pattern, point(0.5, 0, 0)) == color(0.5, 0.5, 0.5)
      assert Gradient.at(pattern, point(0.75, 0, 0)) == color(0.25, 0.25, 0.25)
    end
  end
end
