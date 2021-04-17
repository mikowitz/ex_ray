defmodule ExRay.Material do
  defstruct color: ExRay.white(),
            ambient: 0.1,
            diffuse: 0.9,
            specular: 0.9,
            shininess: 200.0,
            reflective: 0.0,
            pattern: nil

  def new(attrs \\ []) do
    Map.merge(%__MODULE__{}, Enum.into(attrs, %{}))
  end

  def lighting(%__MODULE__{} = material, object, light, point, eyev, normalv, in_shadow \\ false) do
    color =
      if material.pattern do
        ExRay.Pattern.at(material.pattern, object, point)
      else
        material.color
      end

    effective_color = ExRay.multiply(color, light.intensity)

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

    if in_shadow do
      ambient
    else
      ExRay.add(ambient, diffuse) |> ExRay.add(specular)
    end
  end
end
