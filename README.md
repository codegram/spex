# Spex [![Build Status](https://travis-ci.org/codegram/spex.svg?branch=master)](https://travis-ci.org/codegram/spex)

Spex helps you validate your values against value-based schemas.

## Installation

First, add Spex to your `mix.exs`

```elixir
def deps do
  [{:spex, "~> 0.1.0"}]
end
```

Then, update your dependencies:

    $ mix deps.get

## Usage

```elixir
import Spex
```

A spec is always a value. Let's start with the simplest spec, a primitive value:

### Primitive value specs

```elixir
my_simple_spec = 3

Spex.conforms?(my_simple_spec, 3)
# => true

Spex.conforms?(my_simple_spec, 5)
# => false

Spex.conforms?("foo", "foo")
# => true

Spex.conforms?(:bar, :bar)
# => true
```

Primitive values, such as integers, strings and atoms, validate values using
simple equality.

### List specs

Let's move on to a slightly more complex spec: a list. A list spec *must* have
one spec in it, which will validate against all the elements of the validated
list.

```elixir
my_simple_spec = 3

Spex.conforms?([my_simple_spec], [3, 3, 3, 3])
# => true

Spex.conforms?([my_simple_spec], [3, 3, 1, 9])
# => false

Spex.conforms?([my_simple_spec], [])
# => true
```

This last example might have surprised you -- but an empty list *always*
conforms to *any* list spec. If you want your spec to only validate non-empty
lists, we've got you covered:

```elixir
use Spex.DSL

my_simple_spec = 3

Spex.conforms?(non_empty_list(my_simple_spec), [3, 3, 3])
# => true

Spex.conforms?(non_empty_list(my_simple_spec), [])
# => false
```

### Predicate specs

Predicate functions (functions that return true or false) are naturally a very
useful kind of spec too:

```elixir
Spex.conforms?(fn(x) -> x > 3 end, 8)
# => true

Spex.conforms?(fn(x) -> x > 3 end, 1)
# => false

import Integer

Spex.conforms?(&Integer.is_odd/1, 3)
# => true
```

### Map specs

Specs really shine when they can describe arbitrarily nested maps. Map specs to
the rescue:

```elixir
Spex.conforms?(%{person: %{age: fn(x) -> x > 21, name: &Kernel.is_string/1}},
               %{person: %{age: 83, name: "James"}})
# => true

Spex.conforms?(%{person: %{age: fn(x) -> x > 21, name: &Kernel.is_string/1}},
               %{person: %{age: 10, name: 9}})
# => false
```

If you're not interested in the shape of the map, but just more generically its
keys and values, you can use `map`:

```elixir
Spex.conforms?(map(&Kernel.is_atom/1, &Integer.is_even/1),
               %{elapsed: 120, remaining: 90})
# => true

Spex.conforms?(map(&Kernel.is_atom/1, &Integer.is_even/1),
               %{elapsed: 3, remaining: 90})
# => false
```

### Tuple specs

Tuple specs work pretty much like you'd expect:

```elixir
Spex.conforms?({3, fn(x) -> x > 3 end}, {3, 4})
# => true

Spex.conforms?({3, fn(x) -> x > 3 end}, {3, 1})
# => false

Spex.conforms?({3, fn(x) -> x > 3 end}, {1, 4})
# => false
```

### Non-nil specs

Sometimes we don't care what a value is, as long as it is non-nil. `any` is just
for that:

```elixir
use Spex.DSL

Spex.conforms?(any, 3)
# => true

Spex.conforms?(any, nil)
# => false
```

### Optional specs

Sometimes we want to validate a value allowing it to be nil. `optional` is what
we want:

```elixir
use Spex.DSL

Spex.conforms?(optional(3), 3)
# => true

Spex.conforms?(optional(3), nil)
# => true

Spex.conforms?(optional(3), 4)
# => false
```

Naturally, map specs can describe optional keys:

```elixir
use Spex.DSL

Spex.conforms?(%{optional(:name) => "foo"}, %{})
# => true

Spex.conforms?(%{optional(:name) => "foo"}, %{name: "bar"})
# => false
```

And optional values:

```elixir
Spex.conforms?(%{name: optional("foo")}, %{name: nil})
# => true

Spex.conforms?(%{name: optional("foo")}, %{name: "bar"})
# => false
```

### `validate/2` and `validate!/2`

To make specs easier to use within the rest of your code, you can validate a
value against a spec with `validate/2`:

```elixir
Spex.validate(3, 3)
# => {:ok, 3}

Spex.validate(3, 4)
# => {:error, "Value doesn't conform to spec: \n\nValue: 4\n\nSpec: 3"}
```

Or if you'd like to either get the validated value or raise an error,
`validate!/2` is your friend:

```elixir
Spex.validate!(3, 3)
# => 3

Spex.validate!(3, 4)
# raises Spex.ValidationError, "Value doesn't conform to spec: \n\nValue: 4\n\nSpec: 3"
```

## Copyright

Copyright (c) 2016 Codegram. See LICENSE for details.
