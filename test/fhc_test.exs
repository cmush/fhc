defmodule FhcTest do
  use ExUnit.Case
  doctest Fhc

  test "greets the world" do
    assert Fhc.hello() == :world
  end
end
