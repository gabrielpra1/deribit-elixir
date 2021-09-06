defmodule DeribitHttp do
  @moduledoc """
  Handles HTTP requests to the Deribit API
  """

  @api_v2 "/api/v2"

  def get_public(url, params \\ %{}) do
    base_endpoint() <> @api_v2 <> "/public/" <> url
    |> add_url_params(params)
    |> HTTPoison.get()
    |> parse_response()
  end

  def get_private(url, client_id, client_secret, params \\ %{}) do
    url = add_url_params(@api_v2 <> "/private/" <> url, params)
    headers = authorization_headers(url, "", client_id, client_secret)

    base_endpoint() <> url
    |> HTTPoison.get(headers)
    |> parse_response()
  end

  defp authorization_headers(url, body, client_id, client_secret) do
    timestamp = get_timestamp()
    nonce = :crypto.strong_rand_bytes(4) |> Base.encode16()

    text = "#{timestamp}\n#{nonce}\nGET\n#{url}\n#{body}\n"
    signature = hmac(:sha256, client_secret, text) |> Base.encode16()

    ["Authorization": "deri-hmac-sha256 id=#{client_id},ts=#{timestamp},nonce=#{nonce},sig=#{signature}"]
  end

  # TODO: remove when we require OTP 22.1
  if Code.ensure_loaded?(:crypto) and function_exported?(:crypto, :mac, 4) do
    defp hmac(digest, key, data), do: :crypto.mac(:hmac, digest, key, data)
  else
    defp hmac(digest, key, data), do: :crypto.hmac(digest, key, data)
  end

  defp get_timestamp, do: DateTime.utc_now() |> DateTime.to_unix() |> Kernel.*(1000)

  defp add_url_params(url, params) when params == %{}, do: url
  defp add_url_params(url, params), do: url <> "?" <> URI.encode_query(params)

  defp parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}), do: Jason.decode(body)
  defp parse_response({:ok, %HTTPoison.Response{status_code: status, body: body}}), do: {:error, {status, Jason.decode!(body)}}
  defp parse_response({:error, %HTTPoison.Error{reason: reason}}), do: {:error, reason}

  defp base_endpoint do
    case Application.get_env(:deribit, :test) do
      true -> "https://test.deribit.com"
      _ -> "https://www.deribit.com"
    end
  end
end
