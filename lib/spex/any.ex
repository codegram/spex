defmodule Spex.Any do
  defstruct []

  defmodule DSL do
    def any(), do: %Spex.Any{}
  end
end

defimpl Spex.Spec, for: Spex.Any do
  def conforms?(_, nil), do: false
  def conforms?(_, value), do: true
end
