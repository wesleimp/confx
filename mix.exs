defmodule Confx.MixProject do
  use Mix.Project

  @source_url "https://github.com/wesleimp/confx"
  @version "0.1.0"

  def project do
    [
      app: :confx,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Find and load configurations from files",
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:yaml_elixir, "~> 2.8"},
      {:jason, "~> 1.2"},
      {:ex_doc, "~> 0.25", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Weslei Juan Moser Pereira"],
      licenses: ["MIT"],
      links: %{GitHub: @source_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatter_opts: [gfm: true],
      extras: [
        "README.md"
      ]
    ]
  end
end
