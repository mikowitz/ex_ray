defmodule ExRay.Utils do
  def random(), do: :rand.uniform()

  def random(min, max) do
    min + (max - min) * random()
  end

  def linear_to_gamma(t) when t > 0, do: :math.sqrt(t)
  def linear_to_gamma(_), do: 0
end
