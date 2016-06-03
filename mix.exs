defmodule Spex.Mixfile do
  use Mix.Project

  @version File.read!("VERSION") |> String.strip

  def project do
    [app: :spex,
     version: @version,
     elixir: "~> 1.2",
     description: "Validate your Elixir values against value-based specs",
     consolidate_protocols: Mix.env != :test,
     package: package,
     deps: []]
  end

  def application do
    []
  end

  defp package do
    [files: ~w(lib mix.exs README.md LICENSE VERSION),
     name: :spex,
     maintainers: ["Josep M. 'Txus' Bach"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/codegram/spex"}]
  end
end
