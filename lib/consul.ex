defmodule Consul do
  @moduledoc """
  Documentation for Consul.
  """

  require Logger

  def register_service(name, port, check) do
    check = Map.merge(%{Interval: "10s"}, Enum.into(check, %{}))
    payload = %{Name: name, Port: port, Check: check}
    json_payload = Poison.encode!(payload)
    Logger.info("Registering consul service with parameters: #{json_payload}")
    HTTPoison.get(base_url("/agent/service/deregister/#{name}"))
    HTTPoison.post(base_url("/agent/service/register"), json_payload)
  end

  def connect_nodes(service_name) do
    for host <- Consul.Service.addresses(service_name),
      do: :"#{node_name()}@#{host}" |> Node.connect()
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
