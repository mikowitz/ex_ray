defmodule EqualityHelper do
  defmacro __using__(_) do
    quote do
      @epsilon 0.0001

      import Kernel, except: [==: 2]

      def a == b when is_list(a) and is_list(b) do
        assert Enum.zip(a, b) |> Enum.all?(fn {a, b} -> abs(a - b) < @epsilon end)
      end

      def a == b do
        Kernel.==(a, b)
      end
    end
  end
end
