defmodule Consul do
  @moduledoc """
  Documentation for Consul.
  """

  require Logger

  def connect_nodes(service) do
    with {:ok, addresses} <- Consul.Service.addresses(service) do
      for host <- addresses,
        do: :"#{node_name()}@#{host}" |> Node.connect()
    end
  end

  def base_url(path) do
    "http://localhost:8500/v1#{path}"
  end

  @doc """
  Returns node name without host.
  """
  @spec node_name() :: binary()
  def node_name() do
    [name, _host] = node() |> Atom.to_string() |> String.split("@")
    name
  end
end
