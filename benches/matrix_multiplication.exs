defmodule Matrix do
  def multiply(m1, [[_ | _] | _] = m2) do
    rows1 = m1
    cols2 = m2 |> Enum.zip() |> Enum.map(&Tuple.to_list/1)

    for y <- 0..(length(rows1) - 1) do
      for x <- 0..(length(cols2) - 1) do
        ExRay.dot(Enum.at(rows1, y), Enum.at(cols2, x))
      end
    end
  end

  def exact_multiply(
        [[_, _, _, _], [_, _, _, _], [_, _, _, _], [_, _, _, _]] = m1,
        [[_, _, _, _], [_, _, _, _], [_, _, _, _], [_, _, _, _]] = m2
      ) do
    rows1 = m1
    cols2 = m2 |> Enum.zip() |> Enum.map(&Tuple.to_list/1)

    for y <- 0..3 do
      for x <- 0..3 do
        ExRay.dot(Enum.at(rows1, y), Enum.at(cols2, x))
      end
    end
  end

  def exact_multiply(
        [[_, _, _], [_, _, _], [_, _, _]] = m1,
        [[_, _, _], [_, _, _], [_, _, _]] = m2
      ) do
    rows1 = m1
    cols2 = m2 |> Enum.zip() |> Enum.map(&Tuple.to_list/1)

    for y <- 0..2 do
      for x <- 0..2 do
        ExRay.dot(Enum.at(rows1, y), Enum.at(cols2, x))
      end
    end
  end

  def exact_multiply(
        [[_, _], [_, _]] = m1,
        [[_, _], [_, _]] = m2
      ) do
    rows1 = m1
    cols2 = m2 |> Enum.zip() |> Enum.map(&Tuple.to_list/1)

    for y <- 0..1 do
      for x <- 0..1 do
        ExRay.dot(Enum.at(rows1, y), Enum.at(cols2, x))
      end
    end
  end

  def explicit_multiply(
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

  def explicit_multiply(
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

  def explicit_multiply(
        [[a00, a01], [a10, a11]],
        [[b00, b01], [b10, b11]]
      ) do
    [
      [a00 * b00 + a01 * b10, a00 * b01 + a01 * b11],
      [a10 * b00 + a11 * b10, a10 * b01 + a11 * b11]
    ]
  end
end

matrix = fn x ->
  for i <- 1..x do
    Stream.repeatedly(&:random.uniform/0) |> Enum.take(x)
  end
end

Benchee.run(
  %{
    "generic" => fn {a, b} -> Matrix.multiply(a, b) end,
    "specific" => fn {a, b} -> Matrix.exact_multiply(a, b) end,
    "explicit" => fn {a, b} -> Matrix.explicit_multiply(a, b) end
  },
  inputs: %{
    "4x4" => {matrix.(4), matrix.(4)},
    "3x3" => {matrix.(3), matrix.(3)},
    "2x2" => {matrix.(2), matrix.(2)}
  },
  time: 10
)
