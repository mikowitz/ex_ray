defmodule ExRay.Interval do
  defstruct [:min, :max]

  def new(min, max), do: %__MODULE__{min: min, max: max}

  def contains?(%__MODULE__{min: min, max: max}, t) do
    min <= t && t <= max
  end

  def surrounds?(%__MODULE__{min: min, max: max}, t) do
    min < t && t < max
  end
end
