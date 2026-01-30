defmodule HomeTrackerTest do
  use ExUnit.Case
  doctest HomeTracker

  test "greets the world" do
    assert HomeTracker.hello() == :world
  end
end
