# Confx

<!-- MDOC !-->

Find and load configuration from files.

Available file types:
- `JSON`
- `YAML`

## Installation

```elixir
def deps do
  [
    {:confx, "~> 0.1.0"}
  ]
end
```

## Usage

Following the configuration file:

```yaml
# config.yml
my_app:
  host: "http://localhost"
  port: 400
```

It's possible to load this config formatted in Elixir maps:

```elixir
iex(1)> Confx.load("config.yml")
{:ok, %{
  my_app: %{
    host: "http://localhost",
    port: 4000
  }
}}

# Using defaults
iex(2)> Confx.load("config.yml", defaults: [my_app: [method: "POST"]])
{:ok, %{
  my_app: %{
    host: "http://localhost",
    port: 4000,
    method: "POST"
  }
}}
```

Check out the [docs]() for more info.
