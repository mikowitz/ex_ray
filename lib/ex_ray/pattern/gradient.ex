defmodule ExRay.Pattern.Gradient do
  use ExRay.Pattern

  @impl ExRay.Pattern
  def at(%__MODULE__{colors: [ca, cb]}, [x | _]) do
    distance = ExRay.subtract(cb, ca)
    fraction = x - Float.floor(x * 1.0)

    ExRay.add(ca, ExRay.multiply(distance, fraction))
  end
end
