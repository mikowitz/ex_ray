defmodule ExRay.MatrixTest do
  use ExUnit.Case, async: true
  use EqualityHelper

  alias ExRay.Matrix
  doctest Matrix
  import ExRay

  describe "new/1" do
    test "constructing a 4x4 matrix" do
      matrix =
        matrix([
          [1, 2, 3, 4],
          [5.5, 6.5, 7.5, 8.5],
          [9, 10, 11, 12],
          [13.5, 14.5, 15.5, 16.5]
        ])

      assert Matrix.at(matrix, {0, 0}) == 1
      assert Matrix.at(matrix, {0, 3}) == 4
      assert Matrix.at(matrix, {1, 0}) == 5.5
      assert Matrix.at(matrix, {1, 2}) == 7.5
      assert Matrix.at(matrix, {3, 0}) == 13.5
      assert Matrix.at(matrix, {3, 2}) == 15.5
    end

    test "constructing a 2x2 matrix" do
      matrix =
        matrix([
          [-3, 5],
          [1, -2]
        ])

      assert Matrix.at(matrix, {0, 0}) == -3
      assert Matrix.at(matrix, {0, 1}) == 5
      assert Matrix.at(matrix, {1, 0}) == 1
      assert Matrix.at(matrix, {1, 1}) == -2
    end

    test "constructing a 3x3 matrix" do
      matrix =
        matrix([
          [-3, 5, 0],
          [1, -2, -7],
          [0, 1, 1]
        ])

      assert Matrix.at(matrix, {0, 0}) == -3
      assert Matrix.at(matrix, {1, 1}) == -2
      assert Matrix.at(matrix, {2, 2}) == 1
    end

    test "matrices can be compared element-wise for equality" do
      a =
        matrix([
          [1, 2, 3, 4],
          [5, 6, 7, 8],
          [9, 8, 7, 6],
          [5, 4, 3, 2]
        ])

      b =
        matrix([
          [1, 2, 3, 4],
          [5, 6, 7, 8],
          [9, 8, 7, 6],
          [5, 4, 3, 2]
        ])

      c =
        matrix([
          [1, 2, 3, 4],
          [5, 6, 7, 8],
          [9, -8, 7, 6],
          [5, 4, 3, 2]
        ])

      assert a == b
      refute a == c
    end
  end

  describe "multiplication" do
    test "by a matrix" do
      a =
        matrix([
          [1, 2, 3, 4],
          [5, 6, 7, 8],
          [9, 8, 7, 6],
          [5, 4, 3, 2]
        ])

      b =
        matrix([
          [-2, 1, 2, 3],
          [3, 2, 1, -1],
          [4, 3, 6, 5],
          [1, 2, 7, 8]
        ])

      assert multiply(a, b) ==
               matrix([
                 [20, 22, 50, 48],
                 [44, 54, 114, 108],
                 [40, 58, 110, 102],
                 [16, 26, 46, 42]
               ])
    end

    test "by a tuple" do
      a =
        matrix([
          [1, 2, 3, 4],
          [2, 4, 4, 2],
          [8, 6, 4, 1],
          [0, 0, 0, 1]
        ])

      b = [1, 2, 3, 1]

      assert multiply(a, b) == [18, 24, 33, 1]
    end
  end

  describe "identity/1" do
    test "defaults to a 4x4 identity matrix" do
      assert Matrix.identity() ==
               matrix([
                 [1, 0, 0, 0],
                 [0, 1, 0, 0],
                 [0, 0, 1, 0],
                 [0, 0, 0, 1]
               ])
    end

    test "can be set to any size" do
      assert Matrix.identity(3) ==
               matrix([
                 [1, 0, 0],
                 [0, 1, 0],
                 [0, 0, 1]
               ])
    end
  end

  describe "transpose/1" do
    test "transposes a matrix's rows and columns" do
      matrix =
        matrix([
          [0, 9, 3, 0],
          [9, 8, 0, 8],
          [1, 8, 5, 3],
          [0, 0, 5, 8]
        ])

      assert Matrix.transpose(matrix) ==
               matrix([
                 [0, 9, 1, 0],
                 [9, 8, 8, 0],
                 [3, 0, 5, 5],
                 [0, 8, 3, 8]
               ])
    end
  end

  describe "determinant/1" do
    test "returns the determinant of a 2x2 matrix" do
      matrix = matrix([[1, 5], [-3, 2]])

      assert Matrix.determinant(matrix) == 17
    end

    test "of a 3x3 matrix" do
      a =
        matrix([
          [1, 2, 6],
          [-5, 8, -4],
          [2, 6, 4]
        ])

      assert Matrix.cofactor(a, {0, 0}) == 56
      assert Matrix.cofactor(a, {0, 1}) == 12
      assert Matrix.cofactor(a, {0, 2}) == -46

      assert Matrix.determinant(a) == -196
    end

    test "of a 4x4 matrix" do
      a =
        matrix([
          [-2, -8, 3, 5],
          [-3, 1, 7, 3],
          [1, 2, -9, 6],
          [-6, 7, 7, -9]
        ])

      assert Matrix.cofactor(a, {0, 0}) == 690
      assert Matrix.cofactor(a, {0, 1}) == 447
      assert Matrix.cofactor(a, {0, 2}) == 210
      assert Matrix.cofactor(a, {0, 3}) == 51

      assert Matrix.determinant(a) == -4071
    end
  end

  describe "submatrix/2" do
    test "the submatrix of a 3x3 matrix is a 2x2 matrix" do
      matrix =
        matrix([
          [1, 5, 0],
          [-3, 2, 7],
          [0, 6, -3]
        ])

      assert Matrix.Submatrix.submatrix(matrix, {0, 2}) ==
               matrix([
                 [-3, 2],
                 [0, 6]
               ])
    end

    test "the submatrix of a 4x4 matrix is a 3x3 matrix" do
      matrix =
        matrix([
          [-6, 1, 1, 6],
          [-8, 5, 8, 6],
          [-1, 0, 8, 2],
          [-7, 1, -1, 1]
        ])

      assert Matrix.Submatrix.submatrix(matrix, {2, 1}) ==
               matrix([
                 [-6, 1, 6],
                 [-8, 8, 6],
                 [-7, -1, 1]
               ])
    end
  end

  describe "minor/2" do
    test "for a 3x3 matrix is the determinant of the calculated submatrix" do
      a =
        matrix([
          [3, 5, 0],
          [2, -1, -7],
          [6, -1, 5]
        ])

      b = Matrix.Submatrix.submatrix(a, {1, 0})

      assert Matrix.determinant(b) == 25
      assert Matrix.minor(a, {1, 0}) == 25
    end
  end

  describe "cofactor/2" do
    test "is the minor of a matrix, possibly with its sign changed" do
      a =
        matrix([
          [3, 5, 0],
          [2, -1, -7],
          [6, -1, 5]
        ])

      assert Matrix.minor(a, {0, 0}) == -12
      assert Matrix.cofactor(a, {0, 0}) == -12

      assert Matrix.minor(a, {1, 0}) == 25
      assert Matrix.cofactor(a, {1, 0}) == -25
    end
  end

  describe "invertible/1" do
    test "with an invertible matrix" do
      matrix =
        matrix([
          [6, 4, 4, 4],
          [5, 5, 7, 6],
          [4, -9, 3, -7],
          [9, 1, 7, -6]
        ])

      assert Matrix.determinant(matrix) == -2120
      assert Matrix.invertible?(matrix)
    end

    test "with a non-invertible matrix" do
      matrix =
        matrix([
          [-4, 2, -2, -3],
          [9, 6, 2, 6],
          [0, -5, 1, -5],
          [0, 0, 0, 0]
        ])

      assert Matrix.determinant(matrix) == 0
      refute Matrix.invertible?(matrix)
    end
  end

  describe "inverse/1" do
    test "returns the inverse of an invertible matrix" do
      a =
        matrix([
          [-5, 2, 6, -8],
          [1, -5, 1, 8],
          [7, 7, -6, -7],
          [1, -3, 7, 4]
        ])

      b = Matrix.inverse(a)

      assert Matrix.determinant(a) == 532
      assert Matrix.cofactor(a, {2, 3}) == -160

      assert Matrix.at(b, {3, 2}) == -160 / 532

      assert Matrix.cofactor(a, {3, 2}) == 105

      assert Matrix.at(b, {2, 3}) == 105 / 532

      assert b ==
               matrix([
                 [0.21805, 0.45113, 0.24060, -0.04511],
                 [-0.80827, -1.45677, -0.44361, 0.52068],
                 [-0.07895, -0.22368, -0.05263, 0.19737],
                 [-0.52256, -0.81391, -0.30075, 0.30639]
               ])
    end

    test "a second invertible matix" do
      a =
        matrix([
          [8, -5, 9, 2],
          [7, 5, 6, 1],
          [-6, 0, 9, 6],
          [-3, 0, -9, -4]
        ])

      assert Matrix.inverse(a) ==
               matrix([
                 [-0.15385, -0.15385, -0.28205, -0.53846],
                 [-0.07692, 0.12308, 0.02564, 0.03077],
                 [0.35897, 0.35897, 0.43590, 0.92308],
                 [-0.69231, -0.69231, -0.76923, -1.92308]
               ])
    end

    test "and a third invertible matrix" do
      a =
        matrix([
          [9, 3, 0, 9],
          [-5, -2, -6, -3],
          [-4, 9, 6, 4],
          [-7, 6, 6, 2]
        ])

      assert Matrix.inverse(a) ==
               matrix([
                 [-0.04074, -0.07778, 0.14444, -0.22222],
                 [-0.07778, 0.03333, 0.36667, -0.33333],
                 [-0.02901, -0.14630, -0.10926, 0.12963],
                 [0.17778, 0.06667, -0.26667, 0.33333]
               ])
    end

    test "returns an error tuple for a non-invertible matrix" do
      matrix =
        matrix([
          [-4, 2, -2, -3],
          [9, 6, 2, 6],
          [0, -5, 1, -5],
          [0, 0, 0, 0]
        ])

      assert Matrix.inverse(matrix) == {:error, :non_invertible_matrix}
    end

    test "multiplying a product by its inverse" do
      a =
        matrix([
          [3, -9, 7, 3],
          [3, -8, 2, -9],
          [-4, 4, 4, 1],
          [-6, 5, -1, 1]
        ])

      b =
        matrix([
          [8, 2, 2, 2],
          [3, -1, 7, 0],
          [7, 0, 5, 4],
          [6, -2, 0, 5]
        ])

      c = multiply(a, b)

      assert multiply(c, Matrix.inverse(b)) == a
    end
  end
end
