defmodule ExRay.PatternTest do
  use ExRay.TestCase

  alias ExRay.{Matrix, Pattern, Sphere, Transformation}
  alias ExRay.Test.TestPattern

  describe "new/2" do
    test "creates a pattern with a default identity matrix transform" do
      pattern = TestPattern.new([black(), white()])

      assert pattern.transform == Matrix.identity()
    end
  end

  describe "set_transform/2" do
    test "sets the transformation" do
      pattern =
        TestPattern.new([black(), white()])
        |> TestPattern.set_transform(Transformation.translation(1, 2, 3))

      assert pattern.transform == Transformation.translation(1, 2, 3)
    end
  end

  describe "at/3" do
    test "pattern with object transformation" do
      object =
        Sphere.new()
        |> Sphere.set_transform(Transformation.scaling(2, 2, 2))

      pattern = TestPattern.new([black()])

      assert Pattern.at(pattern, object, point(2, 3, 4)) == color(1, 1.5, 2)
    end

    test "pattern with pattern transformation" do
      object = Sphere.new()

      pattern =
        TestPattern.new([black()])
        |> TestPattern.set_transform(Transformation.scaling(2, 2, 2))

      assert Pattern.at(pattern, object, point(2, 3, 4)) == color(1, 1.5, 2)
    end

    test "pattern with object and pattern transformation" do
      object =
        Sphere.new()
        |> Sphere.set_transform(Transformation.scaling(2, 2, 2))

      pattern =
        TestPattern.new([black()])
        |> TestPattern.set_transform(Transformation.translation(0.5, 1, 1.5))

      assert Pattern.at(pattern, object, point(2.5, 3, 3.5)) == color(0.75, 0.5, 0.25)
    end
  end
end
