defmodule ExRay.Computations do
  defstruct [:t, :object, :point, :eyev, :normalv, :inside, :over_point]

  @epsilon 0.0001

  alias ExRay.{Intersection, Ray}

  def new(%Intersection{object: object, t: t}, %Ray{direction: direction} = ray) do
    point = Ray.position(ray, t)
    eyev = ExRay.negate(direction)
    normalv = object.__struct__.normal_at(object, point)

    {inside, normalv} =
      if ExRay.dot(normalv, eyev) < 0 do
        {true, ExRay.negate(normalv)}
      else
        {false, normalv}
      end

    over_point = ExRay.add(point, ExRay.multiply(normalv, @epsilon))

    %__MODULE__{
      t: t,
      object: object,
      point: point,
      eyev: eyev,
      normalv: normalv,
      inside: inside,
      over_point: over_point
    }
  end
end
