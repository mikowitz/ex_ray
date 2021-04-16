defmodule ExRay.CameraTest do
  use ExRay.TestCase

  alias ExRay.{Camera, Matrix, Transformation}

  describe "new/3" do
    test "defines a new camera" do
      c = Camera.new(160, 120, :math.pi() / 2)

      assert c.hsize == 160
      assert c.vsize == 120
      assert c.field_of_view == :math.pi() / 2
      assert c.transform == Matrix.identity()
    end

    test "sets the pixel size properly for a horizontal canvas" do
      c = Camera.new(200, 125, :math.pi() / 2)

      assert c.pixel_size == 0.01
    end

    test "sets the pixel size properly for a vertical canvas" do
      c = Camera.new(125, 200, :math.pi() / 2)

      assert c.pixel_size == 0.01
    end
  end

  describe "ray_for_pixel/3" do
    test "constructing a ray through the center of the canvas" do
      c = Camera.new(201, 101, :math.pi() / 2)
      ray = Camera.ray_for_pixel(c, 100, 50)

      assert ray.origin == origin()
      assert ray.direction == vector(0, 0, -1)
    end

    test "constructing a ray through a corner of the canvas" do
      c = Camera.new(201, 101, :math.pi() / 2)

      ray = Camera.ray_for_pixel(c, 0, 0)
      assert ray.origin == point(0, 0, 0)
      assert ray.direction == vector(0.66519, 0.33259, -0.66851)
    end

    test "constructing a ray when the camera is transformed" do
      c = Camera.new(201, 101, :math.pi() / 2)

      c = %{
        c
        | transform:
            Transformation.rotation_y(:math.pi() / 4) |> Transformation.translation(0, -2, 5)
      }

      ray = Camera.ray_for_pixel(c, 100, 50)
      assert ray.origin == point(0, 2, -5)
      assert ray.direction == vector(:math.sqrt(2) / 2, 0, -:math.sqrt(2) / 2)
    end
  end
end
