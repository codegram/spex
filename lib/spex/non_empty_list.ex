defmodule Spex.NonEmptyList do
  defstruct [:spec]

  defmodule DSL do
    def non_empty_list(spec), do: %Spex.NonEmptyList{spec: spec}
  end
end

defimpl Spex.Spec, for: Spex.NonEmptyList do
  def conforms?(_, []), do: false
  def conforms?(%Spex.NonEmptyList{spec: spec}, [_ | _] = xs) do
    Spex.Spec.conforms?([spec], xs)
  end
  def conforms?(_, _), do: false
end
