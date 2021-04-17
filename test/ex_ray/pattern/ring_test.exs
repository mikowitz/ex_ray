defmodule ExRay.Pattern.RingTest do
  use ExRay.TestCase

  alias ExRay.Pattern.Ring

  describe "at/2" do
    test "ring extends in both x and z" do
      pattern = Ring.new([white(), black()])

      assert Ring.at(pattern, point(0, 0, 0)) == white()
      assert Ring.at(pattern, point(1, 0, 0)) == black()
      assert Ring.at(pattern, point(0, 0, 1)) == black()
      assert Ring.at(pattern, point(0.708, 0, 0.708)) == black()
    end
  end
end
