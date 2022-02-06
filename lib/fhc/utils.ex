defmodule Fhc.Utils do
  require Logger
  alias Fhc.EnvVars
  # alias Calendar.DateTime.Format

  @spec set_headers :: [{<<_::64, _::_*8>>, binary}, ...]
  def set_headers(), do: set_headers([])

  def set_headers(headers) when is_list(headers) do
    request_headers = [{"Authorization", bearer_token()}] ++ headers
    Logger.debug("#{__MODULE__}.set_headers/1 url = #{inspect(request_headers)}")
    request_headers
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

  def build_url(method) when is_binary(method) do
    url = EnvVars.base_url() <> method
    Logger.debug("#{__MODULE__}.build_url/1 url = #{inspect(url)}")
    url
  end

  @spec decode_json_body(binary | {:error, any} | {:ok, any}) :: any
  def decode_json_body(body) when is_binary(body), do: Jason.decode(body) |> decode_json_body()
  def decode_json_body({:ok, json_map}), do: json_map
  def decode_json_body({:error, error}), do: IO.inspect(error, label: "decode_json_body/1 error")

  def bearer_token(), do: "Bearer TODO}"
end
