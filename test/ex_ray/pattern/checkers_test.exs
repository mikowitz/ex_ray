defmodule ExRay.Pattern.CheckersTest do
  use ExRay.TestCase

  alias ExRay.Pattern.Checkers

  describe "at/2" do
    test "checkers repeats in x" do
      pattern = Checkers.new([white(), black()])

      assert Checkers.at(pattern, point(0, 0, 0)) == white()
      assert Checkers.at(pattern, point(0.99, 0, 0)) == white()
      assert Checkers.at(pattern, point(1.01, 0, 0)) == black()
    end

    test "checkers repeats in y" do
      pattern = Checkers.new([white(), black()])

      assert Checkers.at(pattern, point(0, 0, 0)) == white()
      assert Checkers.at(pattern, point(0, 0.99, 0)) == white()
      assert Checkers.at(pattern, point(0, 1.01, 0)) == black()
    end

    test "checkers repeats in z" do
      pattern = Checkers.new([white(), black()])

      assert Checkers.at(pattern, point(0, 0, 0)) == white()
      assert Checkers.at(pattern, point(0, 0, 0.99)) == white()
      assert Checkers.at(pattern, point(0, 0, 1.01)) == black()
    end
  end
end
