defmodule ExRay.LightTest do
  use ExUnit.Case, async: true

  import ExRay

  alias ExRay.Light

  describe "point_light/2" do
    test "creates a light with a position and intensity" do
      intensity = white()
      position = origin()

      light = Light.point_light(position, intensity)

      assert light.position == position
      assert light.intensity == intensity
    end
  end
end
