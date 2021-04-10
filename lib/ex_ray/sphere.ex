defmodule ExRay.Sphere do
  alias ExRay.Matrix

  defstruct [:id, transform: ExRay.Matrix.identity(), material: ExRay.Material.new()]

  def new, do: %__MODULE__{id: make_ref()}

  def set_material(%__MODULE__{} = sphere, %ExRay.Material{} = material) do
    %{sphere | material: material}
  end

  def set_transform(%__MODULE__{} = sphere, matrix) do
    %{sphere | transform: matrix}
  end

  def normal_at(%__MODULE__{transform: transform}, [_, _, _, w] = point) when w == 1.0 do
    object_point = ExRay.multiply(Matrix.inverse(transform), point)
    object_normal = ExRay.subtract(object_point, ExRay.origin())
    [x, y, z, _] = ExRay.multiply(Matrix.transpose(Matrix.inverse(transform)), object_normal)

    ExRay.normalize(ExRay.vector(x, y, z))
  end
end
