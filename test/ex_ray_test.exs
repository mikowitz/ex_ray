defmodule ExRayTest do
  use ExUnit.Case, async: true
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

  describe "operations on colors" do
    test "addition" do
      c1 = color(0.9, 0.6, 0.75)
      c2 = color(0.7, 0.1, 0.25)

      assert add(c1, c2) == color(1.6, 0.7, 1.0)
    end

    test "subtraction" do
      c1 = color(0.9, 0.6, 0.75)
      c2 = color(0.7, 0.1, 0.25)

      assert subtract(c1, c2) == color(0.2, 0.5, 0.5)
    end

    test "multiplying by a scalar" do
      color = color(0.2, 0.3, 0.4)

      assert multiply(color, 2) == color(0.4, 0.6, 0.8)
    end

    test "hadamard product" do
      c1 = color(1, 0.2, 0.4)
      c2 = color(0.9, 1, 0.1)

      assert multiply(c1, c2) == color(0.9, 0.2, 0.04)
    end
  end
end
