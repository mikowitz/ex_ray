defmodule ExRay.World do
  defstruct hittables: []

  def new, do: %__MODULE__{}

  def add(%__MODULE__{hittables: hittables} = world, hittable) do
    %__MODULE__{world | hittables: [hittable | hittables]}
  end

  defimpl ExRay.Hittable do
    alias ExRay.Interval
    alias ExRay.HitRecord

    def hit(%@for{hittables: hittables}, ray, %Interval{min: min, max: max}) do
      Enum.reduce(hittables, {nil, max}, fn hittable, {hr, closest_so_far} ->
        case ExRay.Hittable.hit(hittable, ray, Interval.new(min, closest_so_far)) do
          nil -> {hr, closest_so_far}
          %HitRecord{t: t} = rec -> {rec, t}
        end
      end)
      |> elem(0)
    end
  end
end
