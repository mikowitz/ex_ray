defmodule Vector do
  defstruct [:x, :y, :z, :w]

  def new({x, y, z, w}) do
    %__MODULE__{x: x, y: y, z: z, w: w}
  end

  def new({x, y, z}) do
    %__MODULE__{x: x, y: y, z: z, w: 0}
  end

  def multiply(%__MODULE__{x: x1, y: y1, z: z1, w: w1}, %__MODULE__{x: x2, y: y2, z: z2, w: w2}) do
    new({
      x1 * x2,
      y1 * y2,
      z1 * z2,
      w1 * w2
    })
  end

  def sig(%__MODULE__{} = v1, %__MODULE__{} = v2) do
    new({
      v1.x * v2.x,
      v1.y * v2.y,
      v1.z * v2.z,
      v1.w * v2.w
    })
  end
end

defmodule Arithmetic do
  def direct({x1, y1, z1, w1}, {x2, y2, z2, w2}) do
    {x1 * x2, y1 * y2, z1 * z2, w1 * w2}
  end

  def direct({x1, y1, z1}, {x2, y2, z2}) do
    {x1 * x2, y1 * y2, z1 * z2}
  end

  def direct_list(l1, l2) do
    Enum.zip(l1, l2) |> Enum.map(fn {a, b} -> a * b end)
  end

  def named_list([x1, y1, z1, w1], [x2, y2, z2, w2]) do
    {x1 * x2, y1 * y2, z1 * z2, w1 * w2}
  end

  def named_list([x1, y1, z1], [x2, y2, z2]) do
    {x1 * x2, y1 * y2, z1 * z2}
  end

  def convert(l1, l2) do
    [l1, l2]
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.zip()
    |> Enum.map(fn {a, b} -> a * b end)
    |> List.to_tuple()
  end
end

Benchee.run(
  %{
    "direct" => fn {a, b, _, _} -> Arithmetic.direct(a, b) end,
    "direct_list" => fn {_, _, a, b} -> Arithmetic.direct_list(a, b) end,
    "named_list" => fn {_, _, a, b} -> Arithmetic.named_list(a, b) end,
    "convert" => fn {a, b, _, _} -> Arithmetic.convert(a, b) end,
    "structs" => fn {a, b, _, _} -> Vector.multiply(Vector.new(a), Vector.new(b)) end,
    "structs_sig" => fn {a, b, _, _} -> Vector.sig(Vector.new(a), Vector.new(b)) end
  },
  inputs: %{
    "4ple" => {
      {:random.uniform(), :random.uniform(), :random.uniform(), :random.uniform()},
      {:random.uniform(), :random.uniform(), :random.uniform(), :random.uniform()},
      [:random.uniform(), :random.uniform(), :random.uniform(), :random.uniform()],
      [:random.uniform(), :random.uniform(), :random.uniform(), :random.uniform()]
    },
    "3ple" => {
      {:random.uniform(), :random.uniform(), :random.uniform()},
      {:random.uniform(), :random.uniform(), :random.uniform()},
      [:random.uniform(), :random.uniform(), :random.uniform()],
      [:random.uniform(), :random.uniform(), :random.uniform()]
    }
  },
  time: 10
)
