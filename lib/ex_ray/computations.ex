defmodule ExRay.Computations do
  defstruct [:t, :object, :point, :eyev, :normalv, :inside]

  alias ExRay.{Intersection, Ray, Sphere}

  def new(%Intersection{object: object, t: t}, %Ray{direction: direction} = ray) do
    point = Ray.position(ray, t)
    eyev = ExRay.negate(direction)
    normalv = Sphere.normal_at(object, point)

    {inside, normalv} =
      if ExRay.dot(normalv, eyev) < 0 do
        {true, ExRay.negate(normalv)}
      else
        {false, normalv}
      end

    %__MODULE__{
      t: t,
      object: object,
      point: point,
      eyev: eyev,
      normalv: normalv,
      inside: inside
    }
  end
end
