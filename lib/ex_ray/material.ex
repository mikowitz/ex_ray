defmodule ExRay.Material do
  defstruct [:color, :ambient, :diffuse, :specular, :shininess]

  def new(attrs \\ []) do
    %__MODULE__{
      color: ExRay.white(),
      ambient: 0.1,
      diffuse: 0.9,
      specular: 0.9,
      shininess: 200.0
    }
    |> Map.merge(Enum.into(attrs, %{}))
  end

  def lighting(%__MODULE__{} = material, light, point, eyev, normalv) do
    effective_color = ExRay.multiply(material.color, light.intensity)

    lightv = ExRay.normalize(ExRay.subtract(light.position, point))

    ambient = ExRay.multiply(effective_color, material.ambient)

    light_dot_normal = ExRay.dot(lightv, normalv)

    {diffuse, specular} =
      if light_dot_normal < 0 do
        {ExRay.black(), ExRay.black()}
      else
        diffuse =
          ExRay.multiply(effective_color, material.diffuse)
          |> ExRay.multiply(light_dot_normal)

        reflectv = ExRay.reflect(ExRay.negate(lightv), normalv)
        reflect_dot_eye = ExRay.dot(reflectv, eyev)

        specular =
          if reflect_dot_eye <= 0 do
            ExRay.black()
          else
            factor = :math.pow(reflect_dot_eye, material.shininess)
            ExRay.multiply(light.intensity, material.specular * factor)
          end

        {diffuse, specular}
      end

    ExRay.add(ambient, diffuse) |> ExRay.add(specular)
  end
end
