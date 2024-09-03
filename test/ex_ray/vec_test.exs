defmodule ExRay.VecTest do
  use ExUnit.Case, async: true

  alias ExRay.Vec
  doctest Vec

  describe "Vec.new/0" do
    test "returns the 0 vector" do
      assert Vec.new() == {0, 0, 0}
    end
  end

  describe "Vec.new/3" do
    test "returns the defined vector" do
      assert Vec.new(1, 2, 3) == {1, 2, 3}
    end
  end

  describe "Vec.negate/1" do
    test "returns the negation of the vector" do
      assert Vec.new(1, -2, 3.5) |> Vec.negate() == {-1, 2, -3.5}
    end
  end

  describe "Vec.add/2" do
    test "returns the sum of two vectors" do
      u = Vec.new(1, 2, 3)
      v = Vec.new(2, -3, 4)

      assert Vec.add(u, v) == {3, -1, 7}
    end

    test "addition is commutative" do
      u = Vec.new(1, 2, 3)
      v = Vec.new(2, -3, 4)

      assert Vec.add(u, v) == Vec.add(v, u)
    end
  end

  describe "Vec.sub/2" do
    test "returns the difference of the two vectors" do
      u = Vec.new(1, 2, 3)
      v = Vec.new(2, -3, 4)

      assert Vec.sub(u, v) == {-1, 5, -1}
    end

    test "subtraction is not commutative" do
      u = Vec.new(1, 2, 3)
      v = Vec.new(2, -3, 4)

      assert Vec.sub(v, u) == {1, -5, 1}
    end
  end

  describe "Vec.mul/2" do
    test "returns a vector multiplied by a scalar" do
      u = Vec.new(1, 2, 3)

      assert Vec.mul(u, 1.5) == {1.5, 3, 4.5}
    end

    test "returns the product of two vectors" do
      u = Vec.new(1, 2, 3)
      v = Vec.new(2, -3, 4)

      assert Vec.mul(u, v) == {2, -6, 12}
    end

    test "multiplication is commutative" do
      u = Vec.new(1, 2, 3)
      v = Vec.new(2, -3, 4)

      assert Vec.mul(u, v) == Vec.mul(v, u)
    end
  end

  describe "Vec.div/2" do
    test "returns a vector divided by a scalar" do
      u = Vec.new(1, 2, 3)

      assert Vec.div(u, 2) == {0.5, 1, 1.5}
    end
  end

  describe "Vec.length_squared/1" do
    test "returns the length of a vector squared" do
      u = Vec.new(1, 2, 3)

      assert Vec.length_squared(u) == 14
    end
  end

  describe "Vec.length/1" do
    test "returns the length of a vector" do
      u = Vec.new(1, 2, 3)

      assert Vec.length(u) == :math.sqrt(14)
    end
  end

  describe "Vec.dot/2" do
    test "returns the dot product of two vectors" do
      u = Vec.new(1, 2, 3)
      v = Vec.new(-1, 2, -3)

      assert Vec.dot(u, v) == -6
    end

    test "dot product is commutative" do
      u = Vec.new(1, 2, 3)
      v = Vec.new(-1, 2, -3)

      assert Vec.dot(u, v) == Vec.dot(v, u)
    end
  end

  describe "Vec.cross/2" do
    test "returns the cross product of two vectors" do
      u = Vec.new(1, 2, 3)
      v = Vec.new(-1, 2, -3)

      assert Vec.cross(u, v) == {-12, 0, 4}
    end

    test "cross product is not commutative" do
      u = Vec.new(1, 2, 3)
      v = Vec.new(-1, 2, -3)

      assert Vec.cross(v, u) == {12, 0, -4}
    end
  end

  describe "Vec.unit_vector/1" do
    test "returns the vector scaled to the unit sphere" do
      u = Vec.new(1, 2, 3)

      assert Vec.unit_vector(u) == {1 / :math.sqrt(14), 2 / :math.sqrt(14), 3 / :math.sqrt(14)}
    end
  end
end
