defmodule ExRay.World do
  defstruct light_source: nil, objects: []

  alias ExRay.{Camera, Canvas, Computations, Intersections, Light, Material, Ray}

  def new, do: %__MODULE__{}

  def set_light(%__MODULE__{} = world, %Light{} = light) do
    %{world | light_source: light}
  end

  def add_objects(%__MODULE__{objects: objects} = world, new_objects) do
    %{world | objects: Enum.uniq(objects ++ new_objects)}
  end

  def intersect(%__MODULE__{objects: objects}, %Ray{} = ray) do
    Enum.map(objects, fn object ->
      Ray.intersect(ray, object)
    end)
    |> List.flatten()
    |> Enum.sort_by(& &1.t)
  end

  def shade_hit(
        %__MODULE__{light_source: light} = world,
        %Computations{} = comps,
        recursive_depth \\ 5
      ) do
    shadowed = is_shadowed(world, comps.over_point)

    surface =
      Material.lighting(
        comps.object.material,
        comps.object,
        light,
        comps.over_point,
        comps.eyev,
        comps.normalv,
        shadowed
      )

    reflected = reflected_color(world, comps, recursive_depth)
    refracted = refracted_color(world, comps, recursive_depth)

    ExRay.add(surface, reflected) |> ExRay.add(refracted)
  end

  def color_at(%__MODULE__{} = world, %Ray{} = ray, recursive_depth \\ 5) do
    xs = intersect(world, ray)

    case Intersections.hit(xs) do
      nil ->
        ExRay.black()

      intersection ->
        comps = Computations.new(intersection, ray, xs)
        shade_hit(world, comps, recursive_depth)
    end
  end

  def is_shadowed(%__MODULE__{} = world, [_, _, _, _] = point) do
    v = ExRay.subtract(world.light_source.position, point)
    distance = ExRay.magnitude(v)
    direction = ExRay.normalize(v)

    r = Ray.new(point, direction)
    xs = intersect(world, r)

    hit = Intersections.hit(xs)

    hit && hit.t < distance
  end

  def reflected_color(world, computations, recursive_depth \\ 5)
  def reflected_color(%__MODULE__{}, %Computations{}, 0), do: ExRay.black()

  def reflected_color(
        %__MODULE__{} = world,
        %Computations{
          over_point: over_point,
          reflectv: reflectv,
          object: object
        },
        recursive_depth
      ) do
    if object.material.reflective == 0.0 do
      ExRay.black()
    else
      reflect_ray = ExRay.ray(over_point, reflectv)
      color = color_at(world, reflect_ray, recursive_depth - 1)
      ExRay.multiply(color, object.material.reflective)
    end
  end

  def refracted_color(world, computations, recursive_depth \\ 5)
  def refracted_color(%__MODULE__{}, %Computations{}, 0), do: ExRay.black()

  def refracted_color(
        %__MODULE__{} = world,
        %Computations{object: object} = comps,
        recursive_depth
      ) do
    if object.material.transparency == 0 do
      ExRay.black()
    else
      n_ratio = comps.n1 / comps.n2
      cos_i = ExRay.dot(comps.eyev, comps.normalv)
      sin2_t = n_ratio * n_ratio * (1 - cos_i * cos_i)

      if sin2_t > 1 do
        ExRay.black()
      else
        cos_t = :math.sqrt(1 - sin2_t)

        direction =
          ExRay.subtract(
            ExRay.multiply(comps.normalv, n_ratio * cos_i - cos_t),
            ExRay.multiply(comps.eyev, n_ratio)
          )

        refract_ray = ExRay.ray(comps.under_point, direction)

        color =
          ExRay.multiply(
            color_at(world, refract_ray, recursive_depth - 1),
            object.material.transparency
          )

        if Agent.get(Debugger, fn s -> s end) == true do
          IO.puts("============== Recursive depth: #{recursive_depth}")
          IO.puts("object: #{object.id}")
          IO.puts("n1: #{comps.n1}")
          IO.puts("n2: #{comps.n2}")
          IO.puts("eyev: #{inspect(comps.eyev)}")
          IO.puts("normalv: #{inspect(comps.normalv)}")
          IO.puts("under_point: #{inspect(comps.under_point)}")
          IO.puts("n_ratio: #{n_ratio}")
          IO.puts("cos_i: #{cos_i}")
          IO.puts("sin2_t: #{sin2_t}")
          IO.puts("cos_t: #{cos_t}")
          IO.puts("refract_ray: #{inspect(refract_ray)}")
          IO.puts("refract_color: #{inspect(color)}")
          IO.puts("")
          IO.puts("")
        end

        color
      end
    end
  end

  def render(%__MODULE__{} = world, %Camera{} = camera) do
    Agent.start(fn -> false end, name: Debugger)
    canvas = Canvas.new(camera.hsize, camera.vsize)

    coords =
      for x <- 0..(camera.hsize - 1), y <- 0..(camera.vsize - 1) do
        {x, y}
      end

    size =
      case :io.columns() do
        {:ok, width} -> width - 15
        _ -> 50
      end

    full = length(coords)
    ratio = size / full

    {canvas, _} =
      Enum.reduce(coords, {canvas, 0}, fn {x, y}, {canvas, ct} ->
        done = round(ct * ratio)

        if x == 125 and y == 125 do
          Agent.update(Debugger, fn _ -> true end)
        else
          Agent.update(Debugger, fn _ -> false end)
        end

        # if Mix.env() != :test do
        #   IO.write(
        #     "\r|" <>
        #       String.duplicate("=", done) <>
        #       String.duplicate(" ", size - done) <> "|\t#{round(ct * ratio * (100 / size))}%"
        #   )
        # end

        ray = Camera.ray_for_pixel(camera, x, y)
        color = color_at(world, ray)

        {Canvas.write(canvas, {x, y}, color), ct + 1}
      end)

    if Mix.env() != :test, do: IO.puts("")
    canvas
  end
end
