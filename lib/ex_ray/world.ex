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
        recursive_depth \\ 4
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

    ExRay.add(surface, reflected)
  end

  def color_at(%__MODULE__{} = world, %Ray{} = ray, recursive_depth \\ 4) do
    xs = intersect(world, ray)

    case Intersections.hit(xs) do
      nil ->
        ExRay.black()

      intersection ->
        comps = Computations.new(intersection, ray)
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

  def reflected_color(world, computations, recursive_depth \\ 4)
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

  def render(%__MODULE__{} = world, %Camera{} = camera) do
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

        if Mix.env() != :test do
          IO.write(
            "\r|" <>
              String.duplicate("=", done) <>
              String.duplicate(" ", size - done) <> "|\t#{round(ct * ratio * (100 / size))}%"
          )
        end

        ray = Camera.ray_for_pixel(camera, x, y)
        color = color_at(world, ray)

        {Canvas.write(canvas, {x, y}, color), ct + 1}
      end)

    if Mix.env() != :test, do: IO.puts("")
    canvas
  end
end
