defmodule ExRay.Material.Dielectric do
  defstruct [:refraction_index]

  def new(refraction_index), do: %__MODULE__{refraction_index: refraction_index}

  defimpl ExRay.Material do
    alias ExRay.Color
    alias ExRay.{Ray, Scatter, Vec}

    def scatter(%@for{refraction_index: refraction_index}, ray, hit_record) do
      ri = if hit_record.front_face, do: 1 / refraction_index, else: refraction_index

      unit_direction = Vec.unit_vector(ray.direction)
      cos_theta = min(Vec.dot(Vec.negate(unit_direction), hit_record.normal), 1.0)
      sin_theta = :math.sqrt(1.0 - cos_theta * cos_theta)

      cannot_refract = ri * sin_theta > 1.0

      direction =
        case cannot_refract || reflectance(cos_theta, ri) > :rand.uniform() do
          true -> Vec.reflect(unit_direction, hit_record.normal)
          false -> Vec.refract(unit_direction, hit_record.normal, ri)
        end

      %Scatter{
        attenuation: Color.white(),
        ray: Ray.new(hit_record.point, direction)
      }
    end

    defp reflectance(cosine, refraction_index) do
      r0 = (1 - refraction_index) / (1 + refraction_index)
      r0 = r0 * r0
      r0 + (1 - r0) * :math.pow(1 - cosine, 5)
    end
  end
end
