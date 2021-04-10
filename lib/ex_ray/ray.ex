defmodule ExRay.Ray do
  defstruct [:origin, :direction]

  alias ExRay.{Intersection, Matrix, Sphere}

  def new([_, _, _, ow] = origin, [_, _, _, dw] = direction) when ow == 1.0 and dw == 0.0 do
    %__MODULE__{
      origin: origin,
      direction: direction
    }
  end

  def position(%__MODULE__{origin: origin, direction: direction}, t) do
    ExRay.add(origin, ExRay.multiply(direction, t))
  end

  def intersect(%__MODULE__{} = ray, %Sphere{transform: transform} = sphere) do
    %__MODULE__{origin: origin, direction: direction} = transform(ray, Matrix.inverse(transform))
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

  def transform(%__MODULE__{origin: origin, direction: direction}, matrix) do
    new(
      ExRay.multiply(matrix, origin),
      ExRay.multiply(matrix, direction)
    )
  end
end
