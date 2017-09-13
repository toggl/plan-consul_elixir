defmodule Consul.Service do
  def addresses(name) do
    with {:ok, %{status_code: 200} = response} <- HTTPoison.get(Consul.base_url("/catalog/service/#{name}")),
         {:ok, parsed} <- Poison.decode(response.body) do
      for node_info <- parsed, do: node_info["Address"]
    end
  end
end
