defmodule ExRay.Computations do
  defstruct [
    :t,
    :object,
    :point,
    :eyev,
    :normalv,
    :inside,
    :reflectv,
    :over_point,
    :under_point,
    :n1,
    :n2
  ]

  @epsilon 0.0001

  alias ExRay.{Intersection, Ray}

  def new(
        %Intersection{object: object, t: t} = hit,
        %Ray{direction: direction} = ray,
        intersections \\ []
      ) do
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
    under_point = ExRay.subtract(point, ExRay.multiply(normalv, @epsilon))
    reflectv = ExRay.reflect(direction, normalv)

    {_, n1, n2} =
      Enum.reduce_while(intersections, {[], 1.0, 1.0}, fn intersection, {containers, _, _} ->
        n1 =
          if intersection == hit do
            case containers do
              [] -> 1.0
              _ -> List.last(containers).material.refractive_index
            end
          end

        containers =
          if intersection.object in containers do
            List.delete(containers, intersection.object)
          else
            containers ++ [intersection.object]
          end

        n2 =
          if intersection == hit do
            case containers do
              [] -> 1.0
              _ -> List.last(containers).material.refractive_index
            end
          end

        if intersection == hit do
          {:halt, {containers, n1, n2}}
        else
          {:cont, {containers, 1.0, 1.0}}
        end
      end)

    %__MODULE__{
      t: t,
      object: object,
      point: point,
      eyev: eyev,
      normalv: normalv,
      inside: inside,
      reflectv: reflectv,
      over_point: over_point,
      under_point: under_point,
      n1: n1,
      n2: n2
    }
  end
end
