defmodule ExRay.Color do
  def new(r, g, b), do: {r / 1, g / 1, b / 1}

  def add({r, g, b}, {s, h, c}), do: {r + s, g + h, b + c}

  def mul({r, g, b}, t), do: {r * t, g * t, b * t}

  def black, do: new(0, 0, 0)
  def white, do: new(1, 1, 1)

  def to_ppm({r, g, b}) do
    r = round(255 * r)
    g = round(255 * g)
    b = round(255 * b)

    "#{r} #{g} #{b}"
  end
end
