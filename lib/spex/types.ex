defmodule Spex.Types do
  types = [
    :atom,
    :binary,
    :bitstring,
    :boolean,
    :float,
    :function,
    :integer,
    :list,
    :map,
    :number,
    :pid,
    :port,
    :reference,
    :tuple
  ]

  for t <- types do
    function_name = String.to_atom("is_" <> to_string(t))
    def unquote(Macro.var(t, nil)) do
      unquote({:&, [],
               [{:/, [context: Elixir, import: Kernel],
                 [{{:., [], [{:__aliases__, [alias: false], [:Kernel]}, function_name]}, [], []},
                  1]}]})
    end
  end

  def string, do: &Kernel.is_binary/1
end
