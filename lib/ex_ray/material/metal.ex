defmodule ExRay.Material.Metal do
  defstruct [:albedo, :fuzz]

  def new(albedo, fuzz), do: %__MODULE__{albedo: albedo, fuzz: fuzz}

  defimpl ExRay.Material do
    alias ExRay.{Ray, Scatter, Vec}

    def scatter(%@for{albedo: albedo, fuzz: fuzz}, ray, hit_record) do
      reflected = Vec.reflect(ray.direction, hit_record.normal)
      reflected = Vec.add(Vec.unit_vector(reflected), Vec.mul(Vec.random_unit_vector(), fuzz))

      %Scatter{
        attenuation: albedo,
        ray: Ray.new(hit_record.point, reflected)
      }
    end
  end
end
