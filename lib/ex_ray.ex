defmodule ExRay do
  def generate do
    image_width = 256
    image_height = 256

    format = [
      bar_color: [IO.ANSI.green_background()],
      blank_color: [IO.ANSI.red_background()],
      bar: " ",
      blank: " ",
      left: "",
      right: ""
    ]

    File.open("test.ppm", [:write], fn file ->
      IO.puts(file, "P3\n#{image_width} #{image_height}\n255")

      for y <- 0..(image_height - 1) do
        for x <- 0..(image_width - 1) do
          r = x / (image_width - 1)
          g = y / (image_height - 1)
          b = 0

          ir = round(255.999 * r)
          ig = round(255.999 * g)
          ib = round(255.999 * b)

          IO.puts(file, "#{ir} #{ig} #{ib}")
          ProgressBar.render(y * image_width + x, image_width * image_height, format)
        end
      end
    end)

    IO.puts("")
  end
end
