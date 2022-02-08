defmodule Fhc do
  @moduledoc """
  Documentation for `Fhc`.
  """

  alias Fhc.HttpClient
  alias Fhc.Utils

  defdelegate child_spec(args), to: HttpClient
  defdelegate get(url, headers \\ []), to: HttpClient

  defdelegate post_application_json(url, body, headers \\ []), to: HttpClient

  defdelegate post_application_x_www_form_urlencoded(url, body, headers \\ []),to: HttpClient

  defdelegate post_multipart_form_data(url, body, headers \\ []), to: HttpClient

  # Utilities Api
  defdelegate set_headers(default_headers, headers), to: Utils
  defdelegate build_json_body(map), to: Utils
  defdelegate build_url_encoded_body(map), to: Utils
  defdelegate build_url(base_url, method), to: Utils
  defdelegate decode_json_body(body), to: Utils
  defdelegate bearer_token(), to: Utils
end
