defmodule ExRay.Ray do
  alias ExRay.Vec

  defstruct [:origin, :direction]

  def new({_, _, _} = origin, {_, _, _} = direction) do
    %__MODULE__{origin: origin, direction: direction}
  end

  def at(%__MODULE__{} = ray, t) when is_number(t) do
    Vec.add(ray.origin, Vec.mul(ray.direction, t))
  end
end
