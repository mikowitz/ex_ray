defmodule ExRay.ShapeTest do
  use ExRay.TestCase

  alias ExRay.{Material, Matrix}
  alias ExRay.Test.TestShape

  describe "new/2" do
    test "creates a shape with a default transform of the identity matrix" do
      shape = TestShape.new()

      assert shape.transform == Matrix.identity()
    end

    test "creates a shape with a default material" do
      shape = TestShape.new()

      assert shape.material == Material.new()
    end
  end

  describe "set_material/2" do
    test "updates the material for a sphere" do
      shape = TestShape.new()

      material = ExRay.Material.new(ambient: 1)

      shape = TestShape.set_material(shape, material)

      assert shape.material == material
    end
  end

  describe "set_transform/2" do
    test "updates sthe transform for a sphere" do
      shape = TestShape.new()
      transform = ExRay.Transformation.translation(2, 3, 4)

      shape = TestShape.set_transform(shape, transform)

      assert shape.transform == transform
    end
  end
end
