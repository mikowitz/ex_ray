defmodule ExRay.Shape do
  defmacro __using__(_) do
    quote do
      alias ExRay.{Intersection, Material, Matrix, Ray}

      defstruct [:id, transform: Matrix.identity(), material: Material.new()]

      def new, do: %__MODULE__{id: make_ref()}

      def set_material(%__MODULE__{} = shape, %Material{} = material) do
        %{shape | material: material}
      end

      def set_transform(%__MODULE__{} = shape, matrix) do
        %{shape | transform: matrix}
      end

      @behaviour ExRay.Shape
    end
  end

  @callback normal_at(any, any) :: any
  @callback local_intersect(any, any) :: any
end
