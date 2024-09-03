defmodule ExRay.Sphere do
  alias ExRay.{HitRecord, Ray, Vec}

  defstruct [:center, :radius]

  def new(center, radius) do
    %__MODULE__{center: center, radius: radius}
  end

  defimpl ExRay.Hittable do
    alias ExRay.Interval

    def hit(%@for{center: center, radius: radius}, ray, %Interval{} = interval) do
      oc = Vec.sub(center, ray.origin)
      a = ray.direction |> Vec.length_squared()
      h = Vec.dot(ray.direction, oc)
      c = Vec.length_squared(oc) - radius * radius
      discriminant = h * h - a * c

      if discriminant < 0 do
        nil
      else
        sqrtd = :math.sqrt(discriminant)

        root =
          [(h - sqrtd) / a, (h + sqrtd) / a]
          |> Enum.find(nil, &Interval.surrounds?(interval, &1))

        if root do
          point = Ray.at(ray, root)
          normal = Vec.sub(point, center) |> Vec.div(radius)

          %HitRecord{
            t: root,
            point: point,
            normal: normal
          }
          |> HitRecord.set_front_face(ray, normal)
        else
          nil
        end
      end
    end
  end
end
