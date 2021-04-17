defmodule ExRay.Pattern.Checkers do
  use ExRay.Pattern

  @impl ExRay.Pattern
  def at(%__MODULE__{colors: [ca, cb]}, [x, y, z, _]) do
    if rem(round(floor(x) + floor(y) + floor(z)), 2) == 0, do: ca, else: cb
  end
end
