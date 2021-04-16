defmodule ExRay.Canvas do
  alias ExPng

  def new(width, height) do
    pixels =
      for _ <- 1..height do
        Stream.cycle([ExPng.Color.black()]) |> Enum.take(width)
      end

    ExPng.Image.new(pixels)
  end

  def at(canvas, x, y) do
    <<r, g, b, _a>> = ExPng.Image.at(canvas, {x, y})
    Enum.map([r, g, b], &(&1 / 255))
  end

  def write(canvas, {x, y}, [_, _, _] = color) do
    color = Enum.map(color, &normalize(round(&1 * 255)))
    color = apply(ExPng.Color, :rgb, color)
    ExPng.Image.draw(canvas, {x, y}, color)
  end

  def save(canvas, filename) do
    ExPng.Image.to_file(canvas, filename)
  end

  defp normalize(n) when n < 0, do: 0
  defp normalize(n) when n > 255, do: 255
  defp normalize(n), do: n
end
