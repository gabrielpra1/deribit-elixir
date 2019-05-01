defmodule Deribit do
  @moduledoc """
  Wrapper for the Deribit API
  """

  @public_get [
    "auth",
    "get_time",
    "test",
    "get_announcements",
    "get_book_summary_by_currency",
    "get_book_summary_by_instrument",
    "get_contract_size",
    "get_currencies",
    "get_funding_chart_data",
    "get_historical_volatility",
    "get_index",
    "get_instruments",
    "get_last_settlement_by_currency",
    "get_last_settlement_by_instrument",
    "get_last_trades_by_currency",
    "get_last_trades_by_currency_and_time",
    "get_last_trades_by_instrument",
    "get_last_trades_by_instrument_and_time",
    "get_order_book",
    "get_trade_volumes",
    "ticker"
  ]

  @private_get [
    "get_subaccounts",
    "get_account_summary",
    "get_email_language",
    "get_new_announcements",
    "get_position",
    "get_positions",
    "get_current_deposit_address",
    "get_deposits",
    "get_transfers",
    "get_withdrawals"
  ]

  for endpoint <- @public_get do
    def unquote(String.to_atom(endpoint))(params \\ %{}), do: DeribitHttp.get_public(unquote(endpoint), params)
  end

  for endpoint <- @private_get do
    def unquote(String.to_atom(endpoint))(client_id, client_secret, params \\ %{}) do
      DeribitHttp.get_private(unquote(endpoint), client_id, client_secret, params)
    end

    def unquote(String.to_atom(endpoint))(params \\ %{}) do
      DeribitHttp.get_private(unquote(endpoint), client_id(), client_secret(), params)
    end
  end

  defp client_id, do: Application.get_env(:deribit, :client_id)
  defp client_secret, do: Application.get_env(:deribit, :client_secret)
end
