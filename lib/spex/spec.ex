defprotocol Spex.Spec do
  @fallback_to_any true
  def conforms?(spec, value)
end

defimpl Spex.Spec, for: List do
  def conforms?([spec], xs) do
    Enum.all?(xs, fn(x) -> Spex.Spec.conforms?(spec, x) end)
  end
  def conforms?(_, _), do: raise "List specs must be of the form [single_spec]"
end

defimpl Spex.Spec, for: Function do
  def conforms?(f, value), do: f.(value)
end

defimpl Spex.Spec, for: Map do
  def conforms?(m, value) do
    Enum.reduce(m, true, fn({k, spec}, acc) ->
      acc and case k do
                %Spex.Optional{spec: inner_key} -> !Map.has_key?(value, inner_key) || Spex.Spec.conforms?(spec, value[inner_key])
                _ -> Map.has_key?(value, k) and Spex.Spec.conforms?(spec, value[k])
              end
    end)
  end
end

defimpl Spex.Spec, for: Tuple do
  def conforms?({lspec, rspec}, {lval, rval}) do
    Spex.Spec.conforms?(lspec, lval) and
    Spex.Spec.conforms?(rspec, rval)
  end

  def conforms?(_, _), do: false
end

defimpl Spex.Spec, for: Any do
  def conforms?(s, value), do: s == value
end
