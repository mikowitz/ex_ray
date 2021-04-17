defmodule ExRay.Sphere do
  use ExRay.Shape

  @impl ExRay.Shape
  def normal_at(%__MODULE__{transform: transform}, [_, _, _, w] = point) when w == 1.0 do
    object_point = ExRay.multiply(Matrix.inverse(transform), point)
    object_normal = ExRay.subtract(object_point, ExRay.origin())
    [x, y, z, _] = ExRay.multiply(Matrix.transpose(Matrix.inverse(transform)), object_normal)

    ExRay.normalize(ExRay.vector(x, y, z))
  end

  @impl ExRay.Shape
  def local_intersect(%__MODULE__{} = sphere, %Ray{origin: origin, direction: direction}) do
    sphere_to_ray = ExRay.subtract(origin, ExRay.origin())

    a = ExRay.dot(direction, direction)
    b = 2 * ExRay.dot(direction, sphere_to_ray)
    c = ExRay.dot(sphere_to_ray, sphere_to_ray) - 1

    discriminant = b * b - 4 * a * c

    if discriminant < 0 do
      []
    else
      t1 = (-b - :math.sqrt(discriminant)) / (2 * a)
      t2 = (-b + :math.sqrt(discriminant)) / (2 * a)

      [
        Intersection.new(t1, sphere),
        Intersection.new(t2, sphere)
      ]
    end
  end
end
