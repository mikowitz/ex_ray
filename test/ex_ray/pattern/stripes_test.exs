defmodule ExRay.Pattern.StripesTest do
  use ExRay.TestCase

  alias ExRay.Pattern.Stripes

  describe "at/2" do
    test "a stripe pattern is constant in y" do
      pattern = Stripes.new([white(), black()])

      assert Stripes.at(pattern, point(0, 0, 0)) == white()
      assert Stripes.at(pattern, point(0, 1, 0)) == white()
      assert Stripes.at(pattern, point(0, 2, 0)) == white()
    end

    test "a stripe pattern is constant in z" do
      pattern = Stripes.new([white(), black()])

      assert Stripes.at(pattern, point(0, 0, 0)) == white()
      assert Stripes.at(pattern, point(0, 0, 1)) == white()
      assert Stripes.at(pattern, point(0, 0, 2)) == white()
    end

    test "a stripe pattern alternates in x" do
      pattern = Stripes.new([white(), black()])

      assert Stripes.at(pattern, point(0, 0, 0)) == white()
      assert Stripes.at(pattern, point(0.9, 0, 0)) == white()
      assert Stripes.at(pattern, point(1, 0, 0)) == black()
      assert Stripes.at(pattern, point(-0.1, 0, 0)) == black()
      assert Stripes.at(pattern, point(-1, 0, 0)) == black()
      assert Stripes.at(pattern, point(-1.1, 0, 0)) == white()
    end
  end
end
