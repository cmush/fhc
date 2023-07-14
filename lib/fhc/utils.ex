defmodule Fhc.Utils do
  @moduledoc false
  require Logger

  def set_headers(default_headers, headers \\ [])
      when is_list(default_headers) and is_list(headers) do
    headers = default_headers ++ headers
    # Logger.debug("#{__MODULE__}.set_headers/1 url = #{inspect(headers)}")
    headers
  end

  def build_json_body(map) when is_map(map) do
    case Jason.encode(map) do
      {:ok, json_body} ->
        # Logger.debug("#{__MODULE__}.build_json_body/1 json_body = #{inspect(json_body)}")
        json_body

      _error ->
        # Logger.error("#{__MODULE__}.build_json_body/1 error = #{inspect(error)}")
        :invalid_body
    end
  end

  def build_url_encoded_body(query_params), do: key_value(query_params)
  def build_query_params(query_params), do: key_value(query_params)

  def key_value(map) when is_map(map),
    do:
      map
      |> Enum.map_join("&", fn {key, value} ->
        "#{key}=#{value}"
      end)

  def build_url(base_url, method, query_params \\ %{})
      when is_binary(base_url) and is_binary(method) do
    url =
      if query_params == %{},
        do: base_url <> method,
        else: base_url <> method <> "?" <> build_query_params(query_params)

    # Logger.debug("#{__MODULE__}.build_url/1 url = #{inspect(url)}")
    url
  end

  def decode_response(%Finch.Response{
        headers: headers,
        body: body,
        status: _status
      }) do
    content_type = Enum.into(headers, %{})["content-type"]

    cond do
      String.contains?(content_type, "application/json") -> decode_json_body(body)
      String.contains?(content_type, "application/octet-stream") -> body
      true -> body
    end
  end

  @spec decode_json_body(binary | {:error, any} | {:ok, any}) :: any
  def decode_json_body(body) when is_binary(body),
    do: body |> Jason.decode() |> decode_json_body()

  def decode_json_body({:ok, json_map}), do: json_map
  def decode_json_body({:error, error}), do: error

  def bearer_token(), do: "Bearer TODO}"
end
