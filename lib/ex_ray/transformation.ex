defmodule ExRay.Transformation do
  alias ExRay.Matrix

  @identity Matrix.identity()

  def translation(matrix \\ @identity, x, y, z)

  def translation(@identity, x, y, z) do
    Matrix.new([
      [1, 0, 0, x],
      [0, 1, 0, y],
      [0, 0, 1, z],
      [0, 0, 0, 1]
    ])
  end

  def translation([[_, _, _, _], [_, _, _, _], [_, _, _, _], [_, _, _, _]] = matrix, x, y, z) do
    ExRay.multiply(matrix, translation(x, y, z))
  end

  def scaling(matrix \\ Matrix.identity(), x, y, z)

  def scaling(@identity, x, y, z) do
    Matrix.new([
      [x, 0, 0, 0],
      [0, y, 0, 0],
      [0, 0, z, 0],
      [0, 0, 0, 1]
    ])
  end

  def scaling([[_, _, _, _], [_, _, _, _], [_, _, _, _], [_, _, _, _]] = matrix, x, y, z) do
    ExRay.multiply(matrix, scaling(x, y, z))
  end

  def rotation_x(matrix \\ Matrix.identity(), r)

  def rotation_x(@identity, r) do
    Matrix.new([
      [1, 0, 0, 0],
      [0, :math.cos(r), -:math.sin(r), 0],
      [0, :math.sin(r), :math.cos(r), 0],
      [0, 0, 0, 1]
    ])
  end

  def rotation_x([[_, _, _, _], [_, _, _, _], [_, _, _, _], [_, _, _, _]] = matrix, r) do
    ExRay.multiply(matrix, rotation_x(r))
  end

  def rotation_y(matrix \\ Matrix.identity(), r)

  def rotation_y(@identity, r) do
    Matrix.new([
      [:math.cos(r), 0, :math.sin(r), 0],
      [0, 1, 0, 0],
      [-:math.sin(r), 0, :math.cos(r), 0],
      [0, 0, 0, 1]
    ])
  end

  def rotation_y([[_, _, _, _], [_, _, _, _], [_, _, _, _], [_, _, _, _]] = matrix, r) do
    ExRay.multiply(matrix, rotation_y(r))
  end

  def rotation_z(matrix \\ Matrix.identity(), r)

  def rotation_z(@identity, r) do
    Matrix.new([
      [:math.cos(r), -:math.sin(r), 0, 0],
      [:math.sin(r), :math.cos(r), 0, 0],
      [0, 0, 1, 0],
      [0, 0, 0, 1]
    ])
  end

  def rotation_z([[_, _, _, _], [_, _, _, _], [_, _, _, _], [_, _, _, _]] = matrix, r) do
    ExRay.multiply(matrix, rotation_z(r))
  end

  def shearing(matrix \\ Matrix.identity(), xy, xz, yx, yz, zx, zy)

  def shearing(@identity, xy, xz, yx, yz, zx, zy) do
    Matrix.new([
      [1, xy, xz, 0],
      [yx, 1, yz, 0],
      [zx, zy, 1, 0],
      [0, 0, 0, 1]
    ])
  end

  def shearing(
        [[_, _, _, _], [_, _, _, _], [_, _, _, _], [_, _, _, _]] = matrix,
        xy,
        xz,
        yx,
        yz,
        zx,
        zy
      ) do
    ExRay.multiply(matrix, shearing(xy, xz, yx, yz, zx, zy))
  end
end
