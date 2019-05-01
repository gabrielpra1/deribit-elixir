# Deribit

Client for the [Deribit API v2](https://docs.deribit.com/v2/) over HTTP.


## Installation

The package can be installed by adding `deribit` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:deribit, "~> 0.1.0"}
  ]
end
```

Optionally, configure the client with default credentials to be used in private methods.
Set `test: true` to use the API's test endpoint

```elixir
config :deribit,
  client_id: "",
  client_secret: "",
  test: true # Defaults to false
```

## Usage

### Public

For endpoints with public scope, simply call a function with the name of the endpoint, optionally passing the parameters as a map:

```elixir
iex(1)> Deribit.test
{:ok,
 %{
   "jsonrpc" => "2.0",
   "result" => %{"version" => "1.2.26"},
   "testnet" => true,
   "usDiff" => 1,
   "usIn" => 1556750102206871,
   "usOut" => 1556750102206872
 }}
iex(2)> Deribit.test %{expected_result: "exception"}
{:error,
 {500,
  "{\"jsonrpc\":\"2.0\",\"error\":{\"message\":\"internal_server_error\",\"code\":11094},\"testnet\":true,\"usIn\":1556750145420412,\"usOut\":1556750145420515,\"usDiff\":103}"}}
```

Errors have the format `{:error, {status, body}}` or `{:error, reason}`.

### Private

For endpoints with private scope, you can provide the user credentials or use the ones defined via configuration.

```elixir
iex(1)> Deribit.get_subaccounts
{:error,
 {400,
  "{\"jsonrpc\":\"2.0\",\"error\":{\"message\":\"invalid_credentials\",\"code\":13004},\"testnet\":true,\"usIn\":1556750394788882,\"usOut\":1556750394788903,\"usDiff\":21}"}}
iex(2)> Deribit.get_account_summary("client_id", "client_secret", %{currency: "btc"})
{:error,
 {400,
  "{\"jsonrpc\":\"2.0\",\"error\":{\"message\":\"invalid_credentials\",\"code\":13004},\"testnet\":true,\"usIn\":1556750454519123,\"usOut\":1556750454519148,\"usDiff\":25}"}}
```
