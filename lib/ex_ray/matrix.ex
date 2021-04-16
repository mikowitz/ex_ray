defmodule ExRay.Matrix do
  def new([[_, _], [_, _]] = matrix), do: matrix
  def new([[_, _, _], [_, _, _], [_, _, _]] = matrix), do: matrix
  def new([[_, _, _, _], [_, _, _, _], [_, _, _, _], [_, _, _, _]] = matrix), do: matrix

  def at(matrix, {y, x}) do
    Enum.at(matrix, y) |> Enum.at(x)
  end

  def identity(dim \\ 4) do
    for y <- 1..dim do
      for x <- 1..dim do
        if x == y, do: 1, else: 0
      end
    end
  end

  def transpose([
        [a00, a01, a02, a03],
        [a10, a11, a12, a13],
        [a20, a21, a22, a23],
        [a30, a31, a32, a33]
      ]) do
    new([
      [a00, a10, a20, a30],
      [a01, a11, a21, a31],
      [a02, a12, a22, a32],
      [a03, a13, a23, a33]
    ])
  end

  def invertible?(matrix), do: determinant(matrix) != 0

  def inverse(matrix) do
    case invertible?(matrix) do
      false ->
        {:error, :non_invertible_matrix}

      true ->
        det = determinant(matrix)

        for y <- 0..3 do
          for x <- 0..3 do
            cofactor(matrix, {y, x})
          end
        end
        |> transpose()
        |> Enum.map(fn row ->
          Enum.map(row, &Kernel./(&1, det))
        end)
    end
  end

  def determinant([[a, b], [c, d]]), do: a * d - b * c

  def determinant([[a00, a01, a02] | _] = matrix) do
    a00 * cofactor(matrix, {0, 0}) + a01 * cofactor(matrix, {0, 1}) +
      a02 * cofactor(matrix, {0, 2})
  end

  def determinant([[a00, a01, a02, a03] | _] = matrix) do
    a00 * cofactor(matrix, {0, 0}) + a01 * cofactor(matrix, {0, 1}) +
      a02 * cofactor(matrix, {0, 2}) + a03 * cofactor(matrix, {0, 3})
  end

  def minor(matrix, {row, col}) do
    determinant(ExRay.Matrix.Submatrix.submatrix(matrix, {row, col}))
  end

  def cofactor(matrix, {row, col}) do
    minor = minor(matrix, {row, col})
    if rem(row + col, 2) == 0, do: minor, else: -minor
  end

  def multiply(
        [[a00, a01, a02, a03], [a10, a11, a12, a13], [a20, a21, a22, a23], [a30, a31, a32, a33]],
        [[b00, b01, b02, b03], [b10, b11, b12, b13], [b20, b21, b22, b23], [b30, b31, b32, b33]]
      ) do
    [
      [
        a00 * b00 + a01 * b10 + a02 * b20 + a03 * b30,
        a00 * b01 + a01 * b11 + a02 * b21 + a03 * b31,
        a00 * b02 + a01 * b12 + a02 * b22 + a03 * b32,
        a00 * b03 + a01 * b13 + a02 * b23 + a03 * b33
      ],
      [
        a10 * b00 + a11 * b10 + a12 * b20 + a13 * b30,
        a10 * b01 + a11 * b11 + a12 * b21 + a13 * b31,
        a10 * b02 + a11 * b12 + a12 * b22 + a13 * b32,
        a10 * b03 + a11 * b13 + a12 * b23 + a13 * b33
      ],
      [
        a20 * b00 + a21 * b10 + a22 * b20 + a23 * b30,
        a20 * b01 + a21 * b11 + a22 * b21 + a23 * b31,
        a20 * b02 + a21 * b12 + a22 * b22 + a23 * b32,
        a20 * b03 + a21 * b13 + a22 * b23 + a23 * b33
      ],
      [
        a30 * b00 + a31 * b10 + a32 * b20 + a33 * b30,
        a30 * b01 + a31 * b11 + a32 * b21 + a33 * b31,
        a30 * b02 + a31 * b12 + a32 * b22 + a33 * b32,
        a30 * b03 + a31 * b13 + a32 * b23 + a33 * b33
      ]
    ]
  end

  def multiply(
        [[a00, a01, a02], [a10, a11, a12], [a20, a21, a22]],
        [[b00, b01, b02], [b10, b11, b12], [b20, b21, b22]]
      ) do
    [
      [
        a00 * b00 + a01 * b10 + a02 * b20,
        a00 * b01 + a01 * b11 + a02 * b21,
        a00 * b02 + a01 * b12 + a02 * b22
      ],
      [
        a10 * b00 + a11 * b10 + a12 * b20,
        a10 * b01 + a11 * b11 + a12 * b21,
        a10 * b02 + a11 * b12 + a12 * b22
      ],
      [
        a20 * b00 + a21 * b10 + a22 * b20,
        a20 * b01 + a21 * b11 + a22 * b21,
        a20 * b02 + a21 * b12 + a22 * b22
      ]
    ]
  end

  def multiply(
        [[a00, a01], [a10, a11]],
        [[b00, b01], [b10, b11]]
      ) do
    [
      [a00 * b00 + a01 * b10, a00 * b01 + a01 * b11],
      [a10 * b00 + a11 * b10, a10 * b01 + a11 * b11]
    ]
  end

  def multiply(
        [[a00, a01, a02, a03], [a10, a11, a12, a13], [a20, a21, a22, a23], [a30, a31, a32, a33]],
        [b00, b10, b20, b30]
      ) do
    [
      a00 * b00 + a01 * b10 + a02 * b20 + a03 * b30,
      a10 * b00 + a11 * b10 + a12 * b20 + a13 * b30,
      a20 * b00 + a21 * b10 + a22 * b20 + a23 * b30,
      a30 * b00 + a31 * b10 + a32 * b20 + a33 * b30
    ]
  end
end
