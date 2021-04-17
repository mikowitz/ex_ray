defmodule ExRay.Ray do
  defstruct [:origin, :direction]

  alias ExRay.Matrix

  def new([_, _, _, ow] = origin, [_, _, _, dw] = direction) when ow == 1.0 and dw == 0.0 do
    %__MODULE__{
      origin: origin,
      direction: direction
    }
  end

  def position(%__MODULE__{origin: origin, direction: direction}, t) do
    ExRay.add(origin, ExRay.multiply(direction, t))
  end

  def intersect(%__MODULE__{} = ray, %{id: _id, transform: _} = shape) do
    ray = transform(ray, Matrix.inverse(shape.transform))
    shape.__struct__.local_intersect(shape, ray)
  end

  def transform(%__MODULE__{origin: origin, direction: direction}, matrix) do
    new(
      ExRay.multiply(matrix, origin),
      ExRay.multiply(matrix, direction)
    )
  end
end
