defmodule Fhc.HttpClient do
  alias Finch.Response
  require Logger
  import Fhc.Utils

  @doc """
  - defines the child spec for the Finch connection pool
  - allows us to start up our Finch connection pool from
  """
  @spec child_spec(any) ::
          {Finch, [{:name, Fhc.HttpClient} | {:pools, map}, ...]}
  def child_spec(%{base_url: base_url, pool_size: pool_size} = args) do
    Logger.info(
      "#{__MODULE__}.child_spec/1 Starting the test http client with a pool of #{inspect(pool_size)} connections"
    )

    Logger.debug("#{__MODULE__}.child_spec(#{inspect(args)})")

    {Finch,
     name: __MODULE__,
     pools: %{
       base_url => [size: pool_size]
     }}
  end

  @spec get(binary, maybe_improper_list) ::
          :ok
          | {:error, %{:__exception__ => true, :__struct__ => atom, optional(atom) => any}}
          | %Fhc.Response{body: any, headers: list, status: non_neg_integer}
  def get(url, headers) when is_binary(url) do
    headers = set_headers([], headers)

    :get
    |> Finch.build(
      url,
      headers
    )
    |> Finch.request(__MODULE__)
    |> parse_http_client_response("get/1")
  end

  @spec post_application_json(binary, map, maybe_improper_list) ::
          :ok
          | {:error, %{:__exception__ => true, :__struct__ => atom, optional(atom) => any}}
          | %Fhc.Response{body: any, headers: list, status: non_neg_integer}
  def post_application_json(url, body, headers)
      when is_binary(url) and is_list(headers) and is_map(body) do
    headers = [{"Content-Type", "application/json"}] |> set_headers(headers)

    :post
    |> Finch.build(
      url,
      headers,
      build_json_body(body)
    )
    |> Finch.request(__MODULE__)
    |> parse_http_client_response("post_application_json/3")
  end

  def post_application_x_www_form_urlencoded(
        url,
        body,
        headers
      )
      when is_binary(url) and is_list(headers) and is_map(body) do
    headers = [{"Content-Type", "application/x-www-form-urlencoded"}] |> set_headers(headers)

    :post
    |> Finch.build(
      url,
      headers,
      build_url_encoded_body(body)
    )
    |> Finch.request(__MODULE__)
    |> parse_http_client_response("post_application_x_www_form_urlencoded/3")
  end

  def post_multipart_form_data(url, multipart_body, headers) do
    # {"Content-Length", Multipart.content_length(multipart_body)}
    headers =
      [
        {"Content-Type", Multipart.content_type(multipart_body, "multipart/form-data")}
      ]
      |> set_headers(headers)

    :post
    |> Finch.build(
      url,
      headers,
      {:stream, Multipart.body_stream(multipart_body)}
    )
    |> Finch.request(__MODULE__)
    |> parse_http_client_response("post_multipart_form_data/3")
  end

  defp parse_http_client_response(response, http_client_method)
       when is_binary(http_client_method) do
    # parse finch response
    response
    |> case do
      {:error, %Mint.TransportError{} = error} ->
        Logger.error(
          "#{__MODULE__}.#{http_client_method} failed request, transport error #{inspect(error)}"
        )

        {:error, :service_unavailable, error}

      {:error, error} ->
        Logger.error(
          "#{__MODULE__}.#{http_client_method} failed request, error #{inspect(error)}"
        )

        {:error, error}

      {:ok, %Response{headers: headers, body: _body, status: status} = response} ->
        decoded_body = decode_response(response)

        # Logger.debug(
        #   "#{__MODULE__}.#{http_client_method}'s response headers = #{inspect(headers)}"
        # )

        # Logger.debug(
        #   "#{__MODULE__}.#{http_client_method}'s decoded response body = #{inspect(decoded_body)}"
        # )

        # Logger.debug(
        #   "#{__MODULE__}.#{http_client_method}'s http response status code = #{inspect(status)}"
        # )

        %Fhc.Response{headers: headers, body: decoded_body, status: status}
    end
  end
end
