defmodule ExRay.Vec do
  def new, do: {0.0, 0.0, 0.0}
  def new(x, y, z), do: {x / 1, y / 1, z / 1}

  def negate({x, y, z}), do: {-x, -y, -z}

  def add({x, y, z}, {a, b, c}), do: {x + a, y + b, z + c}
  def sub({x, y, z}, {a, b, c}), do: {x - a, y - b, z - c}

  def mul({x, y, z}, {a, b, c}) do
    {x * a, y * b, z * c}
  end

  def mul({x, y, z}, t) when is_number(t) do
    {x * t, y * t, z * t}
  end

  def div({x, y, z}, t) when is_number(t) do
    {x / t, y / t, z / t}
  end

  def length({_, _, _} = v), do: :math.sqrt(length_squared(v))

  def length_squared({x, y, z}), do: x * x + y * y + z * z

  def dot({x, y, z}, {a, b, c}), do: x * a + y * b + z * c

  def cross({x, y, z}, {a, b, c}) do
    {y * c - z * b, z * a - x * c, x * b - y * a}
  end

  def unit_vector({x, y, z} = v) do
    with l <- __MODULE__.length(v) do
      {x / l, y / l, z / l}
    end
  end
end
