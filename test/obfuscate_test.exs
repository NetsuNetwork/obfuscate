defmodule ObfuscateTest do
  use ExUnit.Case
  doctest Obfuscate

  test "greets the world" do
    assert Obfuscate.hello() == :world
  end
end
