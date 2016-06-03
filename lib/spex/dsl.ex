defmodule Spex.DSL do
  defmacro __using__(opts) do
    quote do
      import Spex.Optional.DSL
      import Spex.NonEmptyList.DSL
      import Spex.Any.DSL
    end
  end
end
