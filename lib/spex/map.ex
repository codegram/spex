defmodule Spex.Map do
  defstruct [:key_spec, :value_spec]

  defmodule DSL do
    def map(key_spec, value_spec), do: %Spex.Map{ key_spec: key_spec, value_spec: value_spec }
  end
end

defimpl Spex.Spec, for: Spex.Map do
  def conforms?(%Spex.Map{ key_spec: key_spec, value_spec: value_spec }, map) when Kernel.is_map(map) do
    Enum.reduce(map, true, fn({k, v}, acc) ->
      acc and Spex.Spec.conforms?(key_spec, k) and Spex.Spec.conforms?(value_spec, v)
    end)
  end

  def conforms?(_, _), do: false
end
