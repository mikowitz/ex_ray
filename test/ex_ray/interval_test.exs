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
end
