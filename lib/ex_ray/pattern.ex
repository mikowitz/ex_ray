defmodule ExRay.Pattern do
  alias ExRay.Matrix

  defmacro __using__(_) do
    quote do
      defstruct [:colors, transform: ExRay.Matrix.identity()]

      def new([_ | _] = colors) do
        %__MODULE__{colors: colors}
      end

      def set_transform(%__MODULE__{} = pattern, transform) do
        %__MODULE__{pattern | transform: transform}
      end

      @behaviour ExRay.Pattern
    end
  end

  def at(pattern, object, world_point) do
    object_point = ExRay.multiply(Matrix.inverse(object.transform), world_point)
    pattern_point = ExRay.multiply(Matrix.inverse(pattern.transform), object_point)

    pattern.__struct__.at(pattern, pattern_point)
  end

  @callback at(any, any) :: any
end
