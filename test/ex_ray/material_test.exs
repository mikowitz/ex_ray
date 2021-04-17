defmodule ExRay.MaterialTest do
  use ExRay.TestCase

  alias ExRay.{Light, Material, Pattern}
  alias ExRay.Test.TestShape

  describe "new/0" do
    test "returns the default material" do
      m = Material.new()

      assert m.color == white()
      assert m.ambient == 0.1
      assert m.diffuse == 0.9
      assert m.specular == 0.9
      assert m.shininess == 200.0
      assert m.reflective == 0.0
    end
  end

  describe "new/1" do
    test "can set attributes on create" do
      m = Material.new(diffuse: 0.5)

      assert m.color == white()
      assert m.ambient == 0.1
      assert m.diffuse == 0.5
      assert m.specular == 0.9
      assert m.shininess == 200.0
    end
  end

  describe "lighting/5" do
    setup :with_material_and_position

    test "with the eye between the light and the surface", %{
      material: material,
      position: position
    } do
      eyev = vector(0, 0, -1)
      normalv = vector(0, 0, -1)
      light = Light.point_light(point(0, 0, -10), white())

      result = Material.lighting(material, TestShape.new(), light, position, eyev, normalv)

      assert result == color(1.9, 1.9, 1.9)
    end

    @root2_2 :math.sqrt(2) / 2

    test "with the eye between the light and the surface, eye offset 45", %{
      material: material,
      position: position
    } do
      eyev = vector(0, @root2_2, -@root2_2)
      normalv = vector(0, 0, -1)
      light = Light.point_light(point(0, 0, -10), white())

      result = Material.lighting(material, TestShape.new(), light, position, eyev, normalv)

      assert result == color(1.0, 1.0, 1.0)
    end

    test "with the eye between the light and the surface, light offset 45", %{
      material: material,
      position: position
    } do
      eyev = vector(0, 0, -1)
      normalv = vector(0, 0, -1)
      light = Light.point_light(point(0, 10, -10), white())

      result = Material.lighting(material, TestShape.new(), light, position, eyev, normalv)

      assert result == color(0.7364, 0.7364, 0.7364)
    end

    test "with the eye in the path of the reflection vector", %{
      material: material,
      position: position
    } do
      eyev = vector(0, -@root2_2, -@root2_2)
      normalv = vector(0, 0, -1)
      light = Light.point_light(point(0, 10, -10), white())

      result = Material.lighting(material, TestShape.new(), light, position, eyev, normalv)

      assert result == color(1.6364, 1.6364, 1.6364)
    end

    test "with the light behind the surface", %{
      material: material,
      position: position
    } do
      eyev = vector(0, 0, -1)
      normalv = vector(0, 0, -1)
      light = Light.point_light(point(0, 0, 10), white())

      result = Material.lighting(material, TestShape.new(), light, position, eyev, normalv)

      assert result == color(0.1, 0.1, 0.1)
    end

    test "with the surface in shadow", %{
      material: material,
      position: positon
    } do
      eyev = vector(0, 0, -1)
      normalv = vector(0, 0, -1)
      light = Light.point_light(point(0, 0, -10), white())
      in_shadow = true

      result =
        Material.lighting(material, TestShape.new(), light, positon, eyev, normalv, in_shadow)

      assert result == color(0.1, 0.1, 0.1)
    end

    test "with a pattern applied" do
      material =
        Material.new(
          pattern: Pattern.Stripes.new([white(), black()]),
          ambient: 1,
          diffuse: 0,
          specular: 0
        )

      eyev = vector(0, 0, -1)
      normalv = vector(0, 0, -1)
      light = Light.point_light(point(0, 0, -10), white())

      c1 = Material.lighting(material, TestShape.new(), light, point(0.9, 0, 0), eyev, normalv)
      c2 = Material.lighting(material, TestShape.new(), light, point(1.1, 0, 0), eyev, normalv)

      assert c1 == white()
      assert c2 == black()
    end
  end

  defp with_material_and_position(_context) do
    {:ok, material: Material.new(), position: origin()}
  end
end
