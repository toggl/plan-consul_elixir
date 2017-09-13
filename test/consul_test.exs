defmodule ConsulTest do
  use ExUnit.Case
  doctest Consul

  test "greets the world" do
    assert Consul.hello() == :world
  end
end
