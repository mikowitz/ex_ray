defmodule ExRay.Pattern.Stripes do
  use ExRay.Pattern

  @impl ExRay.Pattern
  def at(%__MODULE__{} = pattern, [x, _, _, _]) when is_float(x) do
    index = x |> Float.floor() |> round |> rem(2)
    at(pattern, index)
  end

  def at(%__MODULE__{} = pattern, [x, _, _, _]), do: at(pattern, x)

  def at(%__MODULE__{colors: colors}, index) do
    Enum.at(colors, index)
  end
end
