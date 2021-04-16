defmodule ExRay.TestCase do
  defmacro __using__(_) do
    quote do
      use ExUnit.Case, async: true
      use EqualityHelper
      import ExRay
    end
  end
end
