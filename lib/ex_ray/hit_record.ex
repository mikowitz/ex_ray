defmodule ExRay.HitRecord do
  alias ExRay.Vec
  defstruct [:point, :normal, :t, :front_face, :material]

  def new(point, normal, t) do
    %__MODULE__{point: point, normal: normal, t: t}
  end

  def set_front_face(%__MODULE__{} = hr, ray, outward_normal) do
    front_face = Vec.dot(ray.direction, outward_normal) < 0
    normal = if front_face, do: outward_normal, else: Vec.negate(outward_normal)

    %__MODULE__{hr | front_face: front_face, normal: normal}
  end
end
