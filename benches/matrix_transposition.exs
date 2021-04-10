defmodule Matrix do
  def explicit_transpose([
        [a00, a01, a02, a03],
        [a10, a11, a12, a13],
        [a20, a21, a22, a23],
        [a30, a31, a32, a33]
      ]) do
    [
      [a00, a10, a20, a30],
      [a01, a11, a21, a31],
      [a02, a12, a22, a32],
      [a03, a13, a23, a33]
    ]
  end

  def explicit_transpose([
        [a00, a01, a02],
        [a10, a11, a12],
        [a20, a21, a22]
      ]) do
    [
      [a00, a10, a20],
      [a01, a11, a21],
      [a02, a12, a22]
    ]
  end

  def explicit_transpose([
        [a00, a01],
        [a10, a11]
      ]) do
    [
      [a00, a10],
      [a01, a11]
    ]
  end

  def transpose(matrix) do
    matrix
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end

matrix = fn x ->
  for i <- 1..x do
    Stream.repeatedly(&:random.uniform/0) |> Enum.take(x)
  end
end

Benchee.run(
  %{
    "generic" => fn a -> Matrix.transpose(a) end,
    "explicit" => fn a -> Matrix.explicit_transpose(a) end
  },
  inputs: %{
    "4x4" => matrix.(4),
    "3x3" => matrix.(3),
    "2x2" => matrix.(2)
  },
  time: 10
)
