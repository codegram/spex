defmodule Spex.DSL do
  defmacro __using__(opts) do
    quote do
      import Spex.Optional.DSL
      import Spex.NonEmptyList.DSL
      import Spex.Any.DSL
      import Spex.Map.DSL
    end
  end
end
