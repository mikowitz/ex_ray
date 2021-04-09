defmodule EqualityHelper do
  defmacro __using__(_) do
    quote do
      @epsilon 0.0001

      import Kernel, except: [==: 2]

      def a == b when is_tuple(a) and is_tuple(b) do
        {x1, y1, z1, w1} = a
        {x2, y2, z2, w2} = b

        assert abs(x1 - x2) < @epsilon
        assert abs(y1 - y2) < @epsilon
        assert abs(z1 - z2) < @epsilon
        assert abs(w1 - w2) < @epsilon
      end

      def a == b do
        Kernel.==(a, b)
      end
    end
  end
end
