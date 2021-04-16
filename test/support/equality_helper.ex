defmodule EqualityHelper do
  defmacro __using__(_) do
    quote do
      @epsilon 0.0001

      import Kernel, except: [==: 2]

      def a == b when is_list(a) and is_list(b) do
        a = List.flatten(a)
        b = List.flatten(b)
        Enum.zip(a, b) |> Enum.all?(fn {x, y} -> abs(x - y) < @epsilon end)
      end

      def a == b when is_number(a) do
        abs(a - b) < @epsilon
      end

      def a == b do
        Kernel.==(a, b)
      end
    end
  end
end
