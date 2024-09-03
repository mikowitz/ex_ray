defmodule ExRay.Color do
  def new(r, g, b), do: {r / 1, g / 1, b / 1}

  def to_ppm({r, g, b}) do
    r = round(255 * r)
    g = round(255 * g)
    b = round(255 * b)

    "#{r} #{g} #{b}"
  end
end
