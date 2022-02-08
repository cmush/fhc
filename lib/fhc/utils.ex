defmodule Fhc.Utils do
  require Logger

  def set_headers(default_headers, headers \\ [])
      when is_list(default_headers) and is_list(headers) do
    headers = default_headers ++ headers
    Logger.debug("#{__MODULE__}.set_headers/1 url = #{inspect(headers)}")
    headers
  end

  def build_json_body(map) when is_map(map) do
    case Jason.encode(map) do
      {:ok, json_body} ->
        Logger.debug("#{__MODULE__}.build_json_body/1 json_body = #{inspect(json_body)}")
        json_body

      error ->
        Logger.error("#{__MODULE__}.build_json_body/1 error = #{inspect(error)}")
        :invalid_body
    end
  end

  def build_url_encoded_body(map) when is_map(map) do
    url_encoded_body =
      map
      |> Enum.map_join("&", fn {key, value} ->
        "#{key}=#{value}"
      end)

    Logger.debug(
      "#{__MODULE__}.build_url_encoded_body/1 url_encoded_body = #{inspect(url_encoded_body)}"
    )

    url_encoded_body
  end

  def build_url(base_url, method) when is_binary(base_url) and is_binary(method) do
    url = base_url <> method
    Logger.debug("#{__MODULE__}.build_url/1 url = #{inspect(url)}")
    url
  end

  @spec decode_json_body(binary | {:error, any} | {:ok, any}) :: any
  def decode_json_body(body) when is_binary(body), do: Jason.decode(body) |> decode_json_body()
  def decode_json_body({:ok, json_map}), do: json_map
  def decode_json_body({:error, error}), do: IO.inspect(error, label: "decode_json_body/1 error")

  def bearer_token(), do: "Bearer TODO}"
end
