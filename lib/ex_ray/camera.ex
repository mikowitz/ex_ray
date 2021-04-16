defmodule ExRay.Camera do
  alias ExRay.{Matrix, Ray}

  defstruct [
    :hsize,
    :vsize,
    :field_of_view,
    :half_width,
    :half_height,
    :pixel_size,
    transform: Matrix.identity()
  ]

  def new(hsize, vsize, field_of_view) do
    half_view = :math.tan(field_of_view / 2)
    aspect = hsize / vsize

    {half_width, half_height} =
      if aspect >= 1 do
        {half_view, half_view / aspect}
      else
        {half_view * aspect, half_view}
      end

    pixel_size = half_width * 2 / hsize

    %__MODULE__{
      hsize: hsize,
      vsize: vsize,
      field_of_view: field_of_view,
      half_width: half_width,
      half_height: half_height,
      pixel_size: pixel_size
    }
  end

  def set_transform(%__MODULE__{} = camera, transform) do
    %{camera | transform: transform}
  end

  def ray_for_pixel(%__MODULE__{} = camera, px, py) do
    xoffset = (px + 0.5) * camera.pixel_size
    yoffset = (py + 0.5) * camera.pixel_size

    world_x = camera.half_width - xoffset
    world_y = camera.half_height - yoffset

    pixel =
      Matrix.inverse(camera.transform)
      |> ExRay.multiply(ExRay.point(world_x, world_y, -1))

    origin =
      Matrix.inverse(camera.transform)
      |> ExRay.multiply(ExRay.origin())

    direction = ExRay.normalize(ExRay.subtract(pixel, origin))

    Ray.new(origin, direction)
  end
end
