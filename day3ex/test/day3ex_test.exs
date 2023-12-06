defmodule Day3exTest do
  use ExUnit.Case
  doctest Day3ex

  test "greets the world" do
    assert Day3ex.score("test.txt") == 157
  end
end
