defmodule Spex.DSL do
  defmacro __using__(_opts) do
    quote do
      import Spex.Optional.DSL
      import Spex.NonEmptyList.DSL
      import Spex.Any.DSL
      import Spex.Map.DSL
      import Spex.Types
    end
  end
end
