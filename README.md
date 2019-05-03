# Deribit

Client for the [Deribit API v2](https://docs.deribit.com/v2/) over HTTP.


## Installation

The package can be installed by adding `deribit` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:deribit, "~> 0.2.0"}
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
  %{
    "error" => %{"code" => 11094, "message" => "internal_server_error"},
    "jsonrpc" => "2.0",
    "testnet" => true,
    "usDiff" => 101,
    "usIn" => 1556925879289043,
    "usOut" => 1556925879289144
  }}}
```

Errors have the format `{:error, {status, body}}` or `{:error, reason}`.

### Private

For endpoints with private scope, you can provide the user credentials or use the ones defined via configuration.

```elixir
iex(1)> Deribit.get_subaccounts
{:error,
 {400,
  %{
    "error" => %{"code" => 13004, "message" => "invalid_credentials"},
    "jsonrpc" => "2.0",
    "testnet" => true,
    "usDiff" => 19,
    "usIn" => 1556925904685704,
    "usOut" => 1556925904685723
  }}}
iex(2)> Deribit.get_account_summary("client_id", "client_secret", %{currency: "btc"})
{:error,
 {400,
  %{
    "error" => %{"code" => 13004, "message" => "invalid_credentials"},
    "jsonrpc" => "2.0",
    "testnet" => true,
    "usDiff" => 24,
    "usIn" => 1556925927518909,
    "usOut" => 1556925927518933
  }}}
```
