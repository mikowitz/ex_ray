defmodule ExRay.Vec do
  alias ExRay.Utils

  def new, do: {0.0, 0.0, 0.0}
  def new(x, y, z), do: {x / 1, y / 1, z / 1}

  def random do
    new(:rand.uniform(), :rand.uniform(), :rand.uniform())
  end

  def random(min, max) do
    new(Utils.random(min, max), Utils.random(min, max), Utils.random(min, max))
  end

  def negate({x, y, z}), do: {-x, -y, -z}

  def add({x, y, z}, {a, b, c}), do: {x + a, y + b, z + c}
  def sub({x, y, z}, {a, b, c}), do: {x - a, y - b, z - c}

  def mul({x, y, z}, {a, b, c}) do
    {x * a, y * b, z * c}
  end

  def mul({x, y, z}, t) when is_number(t) do
    {x * t, y * t, z * t}
  end

  def div({x, y, z}, t) when is_number(t) do
    {x / t, y / t, z / t}
  end

  def length({_, _, _} = v), do: :math.sqrt(length_squared(v))

  def length_squared({x, y, z}), do: x * x + y * y + z * z

  def dot({x, y, z}, {a, b, c}), do: x * a + y * b + z * c

  def cross({x, y, z}, {a, b, c}) do
    {y * c - z * b, z * a - x * c, x * b - y * a}
  end

  def unit_vector({x, y, z} = v) do
    with l <- __MODULE__.length(v) do
      {x / l, y / l, z / l}
    end
  end

  def random_unit_vector do
    p = random(-1, 1)
    lqs = length_squared(p)

    case 1.0e-160 < lqs && lqs <= 1 do
      true -> __MODULE__.div(p, :math.sqrt(lqs))
      false -> random_unit_vector()
    end
  end

  def random_on_hemisphere(normal) do
    on_unit_sphere = random_unit_vector()

    case dot(on_unit_sphere, normal) > 0.0 do
      true -> on_unit_sphere
      false -> negate(on_unit_sphere)
    end
  end

  def random_in_unit_disk do
    p = new(Utils.random(-1, 1), Utils.random(-1, 1), 0)

    case length_squared(p) < 1 do
      true -> p
      false -> random_in_unit_disk()
    end
  end

  def near_zero?({x, y, z}) do
    Enum.all?([x, y, z], fn t -> abs(t) < 1.0e-8 end)
  end

  def reflect(v, n) do
    sub(v, mul(n, 2 * dot(v, n)))
  end

  def refract(v, n, etai_over_etat) do
    cos_theta = min(dot(negate(v), n), 1.0)
    r_out_perp = mul(add(v, mul(n, cos_theta)), etai_over_etat)
    r_out_parallel = mul(n, -:math.sqrt(abs(1 - length_squared(r_out_perp))))
    add(r_out_perp, r_out_parallel)
  end
end
