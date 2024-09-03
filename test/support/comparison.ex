defmodule ExRay.Test.Support.Comparison do
  defmacro __using__(_) do
    quote do
      @epsilon 0.00001

      import Kernel, except: [==: 2]

      def a == b when is_tuple(a) and is_tuple(b) do
        a = Tuple.to_list(a)
        b = Tuple.to_list(b)

        assert length(a) == length(b)

        Enum.zip(a, b)
        |> Enum.all?(fn {x, y} -> abs(x - y) < @epsilon end)
      end

      def a == b, do: Kernel.==(a, b)
    end
  end
end
