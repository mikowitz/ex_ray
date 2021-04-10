defmodule ExRay.Light do
  defstruct [:intensity, :position]

  def point_light([_, _, _, w] = position, [_, _, _] = intensity) when w == 1.0 do
    %__MODULE__{position: position, intensity: intensity}
  end
end
