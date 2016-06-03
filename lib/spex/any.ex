defmodule Spex.Any do
  defstruct []

  defmodule DSL do
    def any(), do: %Spex.Any{}
  end
end

defimpl Spex.Spec, for: Spex.Any do
  def conforms?(_, value) do
    !Kernel.is_nil(value)
  end
end
