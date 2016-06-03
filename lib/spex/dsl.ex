defmodule Spex.DSL do
  defmacro __using__(opts) do
    quote do
      import Spex.Optional.DSL
      import Spex.NonEmptyList.DSL
    end
  end
end
