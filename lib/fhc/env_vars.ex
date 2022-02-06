defmodule Fhc.EnvVars do
  @moduledoc false

  def base_url,
    do: Application.get_env(:fhc, :base_url) || "http://127.0.0.1:8000"

  def pool_size,
    do: Application.get_env(:fhc, :pool_size) || "5" |> String.to_integer()
end
