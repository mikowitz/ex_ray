defmodule ExRayTest do
  use ExUnit.Case
  use EqualityHelper
  doctest ExRay

  import ExRay

  describe "subtract/2" do
    test "subtracting a vector from a point returns a point" do
      p = point(3, 2, 1)
      v = vector(5, 6, 7)

      assert subtract(p, v) == point(-2, -4, -6)
    end

    test "subtracting a vector from a vector returns a vector" do
      v1 = vector(3, 2, 1)
      v2 = vector(5, 6, 7)

      assert subtract(v1, v2) == vector(-2, -4, -6)
    end
  end

  describe "magnitude/1" do
    test "for a unit vector" do
      v = vector(1, 0, 0)

      assert magnitude(v) == 1.0
    end

    test "for a non-unit vector" do
      v = vector(1, 2, 3)

      assert magnitude(v) == :math.sqrt(14)
    end
  end

  describe "normalize/1" do
    test "converts a vector to a unit vector" do
      v = vector(4, 0, 0)
      assert normalize(v) == vector(1, 0, 0)
    end

    test "converts a more complex vector into a unit vector" do
      v = vector(1, 2, 3)

      assert normalize(v) == vector(0.26726, 0.53452, 0.80178)
    end

    test "a normalized vector's magnitude is always 1" do
      v = vector(1, 2, 3)
      norm = normalize(v)

      assert magnitude(norm) == 1
    end
  end

  describe "dot/2" do
    test "calculates the dot product of two tuples" do
      a = vector(1, 2, 3)
      b = vector(2, 3, 4)

      assert dot(a, b) == 20
    end
  end

  describe "cross/2" do
    test "calculates the cross product of two vectors" do
      a = vector(1, 2, 3)
      b = vector(2, 3, 4)

      assert cross(a, b) == vector(-1, 2, -1)
    end

    test "operand order matters" do
      a = vector(1, 2, 3)
      b = vector(2, 3, 4)

      assert cross(b, a) == vector(1, -2, 1)
    end
  end
end
