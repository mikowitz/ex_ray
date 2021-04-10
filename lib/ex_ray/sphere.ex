defmodule ExRay.Sphere do
  defstruct [:id, transform: ExRay.Matrix.identity()]

  def new, do: %__MODULE__{id: make_ref()}

  def set_transform(%__MODULE__{} = sphere, matrix) do
    %{sphere | transform: matrix}
  end
end
