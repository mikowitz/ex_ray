defmodule ExRay.ColorTest do
  use ExUnit.Case, async: true

  alias ExRay.Color

  describe "Color.new/1" do
    c = Color.new(0.5, 0.2, 0.1)

    assert c == {0.5, 0.2, 0.1}
  end

  describe "Color.to_ppm/1" do
    c = Color.new(1.0, 0, 0.5)

    assert Color.to_ppm(c) == "255 0 128"
  end
end
