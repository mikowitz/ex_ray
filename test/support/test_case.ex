defmodule ExRay.TestCase do
  defmacro __using__(_) do
    quote do
      use ExUnit.Case, async: true
      use EqualityHelper
      import ExRay

      @root2 :math.sqrt(2)
    end
  end
end
