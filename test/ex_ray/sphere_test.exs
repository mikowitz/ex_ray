defmodule ExRay.SphereTest do
  use ExUnit.Case, async: true

  alias ExRay.Sphere

  import ExRay
  import ExRay.Transformation

  describe "new/0" do
    test "creates a sphere with a default transform of the identity matrix" do
      s = sphere()

      assert s.transform == ExRay.Matrix.identity()
    end
  end

  describe "set_transform/2" do
    test "updates sthe transform for a sphere" do
      s = sphere()
      t = translation(2, 3, 4)

      s = Sphere.set_transform(s, t)

      assert s.transform == t
    end
  end
end
