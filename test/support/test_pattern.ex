defmodule ExRay.Test.TestPattern do
  use ExRay.Pattern

  @impl ExRay.Pattern
  def at(_, [x, y, z, _]), do: [x, y, z]
end
