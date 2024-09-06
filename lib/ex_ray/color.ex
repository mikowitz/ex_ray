defmodule ExRay.Color do
  alias ExRay.{Interval, Utils}

  @interval Interval.new(0, 1)

  def new(r, g, b), do: {r / 1, g / 1, b / 1}

  def random do
    new(:rand.uniform(), :rand.uniform(), :rand.uniform())
  end

  def random(min, max) do
    new(Utils.random(min, max), Utils.random(min, max), Utils.random(min, max))
  end

  def add({r, g, b}, {s, h, c}), do: {r + s, g + h, b + c}

  def mul({r, g, b}, {s, h, c}), do: {r * s, g * h, b * c}
  def mul({r, g, b}, t) when is_number(t), do: {r * t, g * t, b * t}

  def black, do: new(0, 0, 0)
  def white, do: new(1, 1, 1)

  def to_ppm({r, g, b}) do
    r = component_value(r)
    g = component_value(g)
    b = component_value(b)

    "#{r} #{g} #{b}"
  end

  defp component_value(t) do
    round(255 * Interval.clamp(@interval, Utils.linear_to_gamma(t)))
  end
end
