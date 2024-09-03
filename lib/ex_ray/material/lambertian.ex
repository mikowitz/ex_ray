defmodule ExRay.Material.Lambertian do
  defstruct [:albedo]

  def new(albedo), do: %__MODULE__{albedo: albedo}

  defimpl ExRay.Material do
    alias ExRay.{Ray, Scatter, Vec}

    def scatter(%@for{albedo: albedo}, _ray, hit_record) do
      scatter_direction = Vec.add(hit_record.normal, Vec.random_unit_vector())

      scatter_direction =
        if Vec.near_zero?(scatter_direction), do: hit_record.normal, else: scatter_direction

      %Scatter{
        attenuation: albedo,
        ray: Ray.new(hit_record.point, scatter_direction)
      }
    end
  end
end
