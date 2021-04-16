defmodule ExRay.TransformationTest do
  use ExUnit.Case, async: true
  use EqualityHelper

  import ExRay.Transformation
  import ExRay

  alias ExRay.Matrix

  describe "translation/3" do
    test "multiplying by a traslation matrix" do
      transform = translation(5, -3, 2)
      point = point(-3, 4, 5)

      assert multiply(transform, point) == point(2, 1, 7)
    end

    test "multiplying by the inverse of a translation matrix" do
      transform = translation(5, -3, 2)
      inv = Matrix.inverse(transform)

      point = point(-3, 4, 5)

      assert multiply(inv, point) == point(-8, 7, 3)
    end

    test "translation does not affect vectors" do
      transform = translation(5, -3, 2)

      vector = vector(-3, 4, 5)

      assert multiply(transform, vector) == vector
    end
  end

  describe "scaling/3" do
    test "applied to a point" do
      transform = scaling(2, 3, 4)
      point = point(-4, 6, 8)

      assert multiply(transform, point) == point(-8, 18, 32)
    end

    test "applied to a vector" do
      transform = scaling(2, 3, 4)
      vector = vector(-4, 6, 8)

      assert multiply(transform, vector) == vector(-8, 18, 32)
    end

    test "multiplying by the inverse of a scaling matrix" do
      transform = scaling(2, 3, 4)
      inv = Matrix.inverse(transform)
      vector = vector(-4, 6, 8)

      assert multiply(inv, vector) == vector(-2, 2, 2)
    end

    test "reflection is scaling by a negative value" do
      transform = scaling(-1, 1, 1)
      point = point(2, 3, 4)

      assert multiply(transform, point) == point(-2, 3, 4)
    end
  end

  @pi :math.pi()
  @sqrt2 :math.sqrt(2)

  describe "rotation_x/3" do
    test "in the positive direction" do
      point = point(0, 1, 0)

      half_quarter = rotation_x(@pi / 4)
      full_quarter = rotation_x(@pi / 2)

      assert multiply(half_quarter, point) == point(0, @sqrt2 / 2, @sqrt2 / 2)
      assert multiply(full_quarter, point) == point(0, 0, 1)
    end

    test "by the inverse in the negative direction" do
      point = point(0, 1, 0)

      half_quarter = rotation_x(@pi / 4)
      half_inv = Matrix.inverse(half_quarter)
      full_quarter = rotation_x(@pi / 2)
      full_inv = Matrix.inverse(full_quarter)

      assert multiply(half_inv, point) == point(0, @sqrt2 / 2, -@sqrt2 / 2)
      assert multiply(full_inv, point) == point(0, 0, -1)
    end
  end

  describe "rotation_y/3" do
    test "in the positive direction" do
      point = point(0, 0, 1)

      half_quarter = rotation_y(@pi / 4)
      full_quarter = rotation_y(@pi / 2)

      assert multiply(half_quarter, point) == point(@sqrt2 / 2, 0, @sqrt2 / 2)
      assert multiply(full_quarter, point) == point(1, 0, 0)
    end

    test "by the inverse in the negative direction" do
      point = point(0, 0, 1)

      half_quarter = rotation_y(@pi / 4)
      half_inv = Matrix.inverse(half_quarter)
      full_quarter = rotation_y(@pi / 2)
      full_inv = Matrix.inverse(full_quarter)

      assert multiply(half_inv, point) == point(-@sqrt2 / 2, 0, @sqrt2 / 2)
      assert multiply(full_inv, point) == point(-1, 0, 0)
    end
  end

  describe "rotation_z/3" do
    test "in the positive direction" do
      point = point(0, 1, 0)

      half_quarter = rotation_z(@pi / 4)
      full_quarter = rotation_z(@pi / 2)

      assert multiply(half_quarter, point) == point(-@sqrt2 / 2, @sqrt2 / 2, 0)
      assert multiply(full_quarter, point) == point(-1, 0, 0)
    end

    test "by the inverse in the negative direction" do
      point = point(0, 1, 0)

      half_quarter = rotation_z(@pi / 4)
      half_inv = Matrix.inverse(half_quarter)
      full_quarter = rotation_z(@pi / 2)
      full_inv = Matrix.inverse(full_quarter)

      assert multiply(half_inv, point) == point(@sqrt2 / 2, @sqrt2 / 2, 0)
      assert multiply(full_inv, point) == point(1, 0, 0)
    end
  end

  describe "shearing/6" do
    test "moves x in proportion to y" do
      transform = shearing(1, 0, 0, 0, 0, 0)
      point = point(2, 3, 4)

      assert multiply(transform, point) == point(5, 3, 4)
    end

    test "moves x in proportion to z" do
      transform = shearing(0, 1, 0, 0, 0, 0)
      point = point(2, 3, 4)

      assert multiply(transform, point) == point(6, 3, 4)
    end

    test "moves y in proportion to x" do
      transform = shearing(0, 0, 1, 0, 0, 0)
      point = point(2, 3, 4)

      assert multiply(transform, point) == point(2, 5, 4)
    end

    test "moves y in proportion to z" do
      transform = shearing(0, 0, 0, 1, 0, 0)
      point = point(2, 3, 4)

      assert multiply(transform, point) == point(2, 7, 4)
    end

    test "moves z in proportion to x" do
      transform = shearing(0, 0, 0, 0, 1, 0)
      point = point(2, 3, 4)

      assert multiply(transform, point) == point(2, 3, 6)
    end

    test "moves z in proportion to y" do
      transform = shearing(0, 0, 0, 0, 0, 1)
      point = point(2, 3, 4)

      assert multiply(transform, point) == point(2, 3, 7)
    end
  end

  describe "chaining transformations" do
    test "individual transformations are chained in sequence" do
      point = point(1, 0, 1)

      a = rotation_x(@pi / 2)
      b = scaling(5, 5, 5)
      c = translation(10, 5, 7)

      p2 = multiply(a, point)
      assert p2 == point(1, -1, 0)

      p3 = multiply(b, p2)
      assert p3 == point(5, -5, 0)

      p4 = multiply(c, p3)
      assert p4 == point(15, 0, 7)
    end

    test "chained transformations must be applied in reverse order" do
      point = point(1, 0, 1)

      a = rotation_x(@pi / 2)
      b = scaling(5, 5, 5)
      c = translation(10, 5, 7)

      t = multiply(c, b) |> multiply(a)
      assert multiply(t, point) == point(15, 0, 7)
    end

    test "transformations can be chained using Elixir piping" do
      point = point(1, 0, 1)

      t =
        translation(10, 5, 7)
        |> scaling(5, 5, 5)
        |> rotation_x(@pi / 2)

      assert multiply(t, point) == point(15, 0, 7)
    end
  end

  describe "view_transform/3" do
    test "for the default orientation" do
      from = point(0, 0, 0)
      to = point(0, 0, -1)
      up = vector(0, 1, 0)

      assert view_transform(from, to, up) == Matrix.identity()
    end

    test "looking in the positive z direction" do
      from = point(0, 0, 0)
      to = point(0, 0, 1)
      up = vector(0, 1, 0)

      assert view_transform(from, to, up) == scaling(-1, 1, -1)
    end

    test "the view transformation moves the world" do
      from = point(0, 0, 8)
      to = point(0, 0, 0)
      up = vector(0, 1, 0)

      assert view_transform(from, to, up) == translation(0, 0, -8)
    end

    test "an arbitrary view transformation" do
      from = point(1, 3, 2)
      to = point(4, -2, 8)
      up = vector(1, 1, 0)

      assert view_transform(from, to, up) ==
               matrix([
                 [-0.50709, 0.50709, 0.67612, -2.36643],
                 [0.76772, 0.60609, 0.12122, -2.82843],
                 [-0.35857, 0.59761, -0.71714, 0.00000],
                 [0.00000, 0.00000, 0.00000, 1.00000]
               ])
    end
  end
end
