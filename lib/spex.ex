defmodule Spex do
  alias Spex.Spec

  defmodule ValidationError do
    defexception message: "Validation error checking conformance to a spec"
  end

  def conforms?(spec, value) do
    Spec.conforms?(spec, value)
  end

  def validate(spec, value) do
    if Spec.conforms?(spec, value) do
      {:ok, value}
    else
      iv = inspect value
      is = inspect spec
      {:error, "Value doesn't conform to spec: \n\nValue: #{iv}\n\nSpec: #{is}\n"}
    end
  end

  def validate!(spec, value) do
    case validate(spec, value) do
      {:ok, v} -> v
      {:error, error} -> raise ValidationError, error
    end
  end
end
