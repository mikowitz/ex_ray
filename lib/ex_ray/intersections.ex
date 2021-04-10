defmodule ExRay.Intersections do
  def hit(xs) do
    xs
    |> Enum.sort_by(& &1.t)
    |> Enum.find(&(&1.t > 0))
  end
end
