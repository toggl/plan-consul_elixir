defmodule Consul.Service do
  require Logger

  def register(name, port, check) do
    check = Map.merge(%{Interval: "10s"}, Enum.into(check, %{}))
    payload = %{Name: name, Port: port, Check: check}
    json_payload = Poison.encode!(payload)
    Logger.info("Registering consul service with parameters: #{json_payload}")
    HTTPoison.get(Consul.base_url("/agent/service/deregister/#{name}"))
    HTTPoison.post(Consul.base_url("/agent/service/register"), json_payload)
  end

  def addresses(name) do
    with {:ok, %{status_code: 200} = response} <- HTTPoison.get(Consul.base_url("/catalog/service/#{name}")),
         {:ok, parsed} <- Poison.decode(response.body) do
      for node_info <- parsed, do: node_info["Address"]
    end
  end
end
