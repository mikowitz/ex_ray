defmodule ExRay.Test.TestShape do
  use ExRay.Shape

  @impl ExRay.Shape
  def normal_at(_, _), do: nil

  @impl ExRay.Shape
  def local_intersect(_, _), do: nil
end
