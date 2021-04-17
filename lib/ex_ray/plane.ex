defmodule ExRay.Plane do
  use ExRay.Shape

  @impl ExRay.Shape
  def normal_at(%__MODULE__{transform: transform}, [_, _, _, _]) do
    [x, y, z, _] =
      transform
      |> Matrix.inverse()
      |> Matrix.transpose()
      |> Matrix.multiply(ExRay.vector(0, 1, 0))

    world_normal = ExRay.vector(x, y, z)

    ExRay.normalize(world_normal)
  end

  @impl ExRay.Shape
  def local_intersect(%__MODULE__{} = plane, %Ray{direction: [_, dy, _, _], origin: [_, oy, _, _]}) do
    if abs(dy) < 0.0001 do
      []
    else
      t = -oy / dy
      [Intersection.new(t, plane)]
    end
  end
end
