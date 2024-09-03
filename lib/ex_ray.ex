defmodule ExRay do
  alias ExRay.{Color, Vec}

  def generate do
    image_width = 256
    image_height = 256

    File.open("test.ppm", [:write], fn file ->
      IO.puts(file, "P3\n#{image_width} #{image_height}\n255")

      for y <- 0..(image_height - 1) do
        for x <- 0..(image_width - 1) do
          r = x / (image_width - 1)
          g = y / (image_height - 1)
          b = 0

          color = color(r, g, b)

          IO.puts(file, Color.to_ppm(color))

          ProgressBar.render(
            y * image_width + x,
            image_width * image_height,
            progress_bar_format()
          )
        end
      end
    end)

    IO.puts("")
  end

  def point(x, y, z), do: Vec.new(x, y, z)
  def vector(x, y, z), do: Vec.new(x, y, z)
  def color(r, g, b), do: Color.new(r, g, b)

  defp progress_bar_format do
    [
      bar_color: [IO.ANSI.green_background()],
      blank_color: [IO.ANSI.red_background()],
      bar: " ",
      blank: " ",
      left: "",
      right: "",
      width: 50
    ]
  end
end
