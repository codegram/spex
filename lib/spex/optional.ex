defmodule Spex.Optional do
  defstruct [:spec]

  defmodule DSL do
    def optional(spec), do: %Spex.Optional{spec: spec}
  end
end

defimpl Spex.Spec, for: Spex.Optional do
  def conforms?(%Spex.Optional{spec: spec}, nil), do: true
  def conforms?(%Spex.Optional{spec: spec}, value), do: Spex.Spec.conforms?(spec, value)
end
