defmodule ExRay.Canvas do
  alias ExPng

  def new(width, height) do
    pixels =
      for _ <- 1..height do
        Stream.cycle([ExPng.Color.black()]) |> Enum.take(width)
      end

    ExPng.Image.new(pixels)
  end

  def write(canvas, {x, y}, [_, _, _] = color) do
    color = Enum.map(color, &round(&1 * 255))
    color = apply(ExPng.Color, :rgb, color)
    ExPng.Image.draw(canvas, {x, y}, color)
  end

  def save(canvas, filename) do
    ExPng.Image.to_file(canvas, filename)
  end
end
