defmodule ExRay.Intersection do
  defstruct [:t, :object]

  def new(t, object) do
    %__MODULE__{
      t: t,
      object: object
    }
  end
end
