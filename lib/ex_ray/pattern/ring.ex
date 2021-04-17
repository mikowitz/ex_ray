defmodule ExRay.Pattern.Ring do
  use ExRay.Pattern

  @impl ExRay.Pattern
  def at(%__MODULE__{colors: [ca, cb]}, [x, _, z, _]) do
    if rem(round(Float.floor(:math.sqrt(x * x + z * z))), 2) == 0 do
      ca
    else
      cb
    end
  end
end
