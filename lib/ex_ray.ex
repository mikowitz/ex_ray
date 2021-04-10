defmodule ExRay do
  @doc """
  Returns a 4-ple with a final element 1.0 representing a point

    iex> ExRay.point(1, 2, 3)
    [1, 2, 3, 1]
  """
  def point(x, y, z) do
    [x, y, z, 1]
  end

  @doc """
  Returns a 4-ple with a final element 1.0 representing a vector

    iex> ExRay.vector(1, 2, 3)
    [1, 2, 3, 0]
  """
  def vector(x, y, z) do
    [x, y, z, 0]
  end

  @doc """
  Returns an RGB 3-ple

    iex> ExRay.color(0.5, 0.4, 1)
    [0.5, 0.4, 1]

  """
  def color(r, g, b), do: [r, g, b]

  defdelegate matrix(m), to: ExRay.Matrix, as: :new
  defdelegate ray(o, d), to: ExRay.Ray, as: :new
  defdelegate sphere(), to: ExRay.Sphere, as: :new

  def origin, do: point(0, 0, 0)
  def black, do: color(0, 0, 0)
  def white, do: color(1, 1, 1)

  @doc """
  Adds two tuples together

    iex> a = ExRay.point(3, -2, 5)
    iex> b = ExRay.vector(-2, 3, 1)
    iex> ExRay.add(a, b)
    [1, 1, 6, 1]

  """
  def add([x1, y1, z1, w1], [x2, y2, z2, w2]) do
    [
      x1 + x2,
      y1 + y2,
      z1 + z2,
      w1 + w2
    ]
  end

  def add([r1, g1, b1], [r2, g2, b2]) do
    [r1 + r2, g1 + g2, b1 + b2]
  end

  @doc """
  Subtracts one tuple from another

    iex> a = ExRay.point(3, 2, 1)
    iex> b = ExRay.point(5, 6, 7)
    iex> ExRay.subtract(a, b)
    [-2, -4, -6, 0]

  """
  def subtract([x1, y1, z1, w1], [x2, y2, z2, w2]) do
    [
      x1 - x2,
      y1 - y2,
      z1 - z2,
      w1 - w2
    ]
  end

  def subtract([r1, y1, b1], [r2, y2, b2]) do
    [
      r1 - r2,
      y1 - y2,
      b1 - b2
    ]
  end

  @doc """
  Can multiply a tuple by a scalar

    iex> a = ExRay.vector(1, -2, 3)
    iex> ExRay.multiply(a, 3.5)
    [3.5, -7.0, 10.5, 0.0]

  """
  def multiply([x, y, z, w], s) when is_number(s) do
    [x * s, y * s, z * s, w * s]
  end

  def multiply([r, g, b], s) when is_number(s) do
    [r * s, g * s, b * s]
  end

  def multiply([r1, g1, b1], [r2, g2, b2]) do
    [r1 * r2, g1 * g2, b1 * b2]
  end

  def multiply(m1, m2), do: ExRay.Matrix.multiply(m1, m2)

  @doc """
  Can divide a tuple by a scalar

    iex> a = ExRay.vector(1, -2, 3)
    iex> ExRay.divide(a, 2)
    [0.5, -1.0, 1.5, 0.0]

  """
  def divide([x, y, z, w], s) when is_number(s) do
    [x / s, y / s, z / s, w / s]
  end

  @doc """
  Negates a tuple by element

    iex> a = [1, 2, 3, -4]
    iex> ExRay.negate(a)
    [-1, -2, -3, 4]

  """
  def negate([x, y, z, w]) do
    [-x, -y, -z, -w]
  end

  def magnitude([x, y, z, w]) do
    :math.sqrt(x * x + y * y + z * z + w * w)
  end

  def normalize([x, y, z, w] = t) do
    with mag <- magnitude(t) do
      [x / mag, y / mag, z / mag, w / mag]
    end
  end

  def dot([x1, y1, z1, w1], [x2, y2, z2, w2]) do
    x1 * x2 + y1 * y2 + z1 * z2 + w1 * w2
  end

  def dot([x1, y1, z1], [x2, y2, z2]) do
    x1 * x2 + y1 * y2 + z1 * z2
  end

  def dot([x1, y1], [x2, y2]) do
    x1 * x2 + y1 * y2
  end

  def cross([x1, y1, z1, _], [x2, y2, z2, _]) do
    vector(
      y1 * z2 - z1 * y2,
      z1 * x2 - x1 * z2,
      x1 * y2 - y1 * x2
    )
  end

  def reflect(vector, normal) do
    subtract(
      vector,
      multiply(normal, 2 * dot(vector, normal))
    )
  end
end
