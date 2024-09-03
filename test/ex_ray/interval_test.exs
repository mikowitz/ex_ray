defmodule ExRay.IntervalTest do
  use ExUnit.Case, async: true

  alias ExRay.Interval

  describe "Interval.contains?/2" do
    test "includes values inside the interval" do
      i = Interval.new(1, 9)

      assert Interval.contains?(i, 1.0001)
      assert Interval.contains?(i, 8.9999)
    end

    test "includes the boundaries of the interval" do
      i = Interval.new(1, 9)

      assert Interval.contains?(i, 1)
      assert Interval.contains?(i, 9)
    end

    test "excludes anything outside the interval" do
      i = Interval.new(1, 9)

      refute Interval.contains?(i, 0.9999)
      refute Interval.contains?(i, 9.0001)
    end
  end

  describe "Interval.surrounds?/2" do
    test "includes values inside the interval" do
      i = Interval.new(1, 9)

      assert Interval.surrounds?(i, 1.0001)
      assert Interval.surrounds?(i, 8.9999)
    end

    test "excludes the boundaries of the interval" do
      i = Interval.new(1, 9)

      refute Interval.surrounds?(i, 1)
      refute Interval.surrounds?(i, 9)
    end

    test "excludes anything outside the interval" do
      i = Interval.new(1, 9)

      refute Interval.surrounds?(i, 0.9999)
      refute Interval.surrounds?(i, 9.0001)
    end
  end

  describe "Interval.clamp/2" do
    test "clamps a value below the interval to its minimum value" do
      i = Interval.new(1, 10)
      assert Interval.clamp(i, 0.9999) == 1
    end

    test "clamps a value above the interval to its maximum value" do
      i = Interval.new(1, 10)
      assert Interval.clamp(i, 10.0001) == 10
    end

    test "does not change a value inside the interval (inclusive)" do
      i = Interval.new(1, 10)

      for x <- [1, 10, 4.5, :math.sqrt(80)] do
        assert Interval.clamp(i, x) == x
      end
    end
  end
end
