defmodule SpexTest do
  use ExUnit.Case
  doctest Spex

  import Spex
  alias Spex.Spec
  use Spex.DSL

  require Integer

  test "primitive value specs validate by equality" do
    assert Spec.conforms?(3, 3)
    assert Spec.conforms?("foo", "foo")
    assert Spec.conforms?(:bar, :bar)
    refute Spec.conforms?("foo", "bar")
  end

  test "(one-element) list specs validate a spec against all elements of a (possibly empty) list" do
    assert Spec.conforms?([3], [3])
    refute Spec.conforms?([3], [4])
    assert Spec.conforms?([3], [])
  end

  test "non-empty list specs validate a spec against all elements of a non-empty list" do
    assert Spec.conforms?(non_empty_list(3), [3])
    refute Spec.conforms?(non_empty_list(3), [])
  end

  test "optional specs validate values that are possibly nil" do
    assert Spec.conforms?(optional(3), 3)
    assert Spec.conforms?(optional(3), nil)
    refute Spec.conforms?(optional(3), 4)
  end

  test "simple map specs validate maps" do
    assert Spec.conforms?(%{foo: :bar}, %{foo: :bar})
    refute Spec.conforms?(%{foo: :bar}, %{bar: :bar})
  end

  test "recursive map specs validate nested maps" do
    assert Spec.conforms?(%{foo: %{bar: 3}}, %{foo: %{bar: 3}})
    refute Spec.conforms?(%{foo: %{bar: 3}}, %{foo: %{bar: 4}})
  end

  test "map specs can have optional values" do
    assert Spec.conforms?(%{foo: optional(3)}, %{foo: nil})
    refute Spec.conforms?(%{foo: optional(3)}, %{})
  end

  test "map specs can have optional keys" do
    assert Spec.conforms?(%{optional(:foo) => 3}, %{foo: 3})
    assert Spec.conforms?(%{optional(:foo) => 3}, %{})
    refute Spec.conforms?(%{optional(:foo) => 3}, %{foo: 5})
  end

  test "function specs validate by application" do
    assert Spec.conforms?(&Integer.is_even/1, 2)
    refute Spec.conforms?(&Integer.is_even/1, 3)
  end

  test "tuple specs validate each side recursively" do
    assert Spec.conforms?({3, &Integer.is_even/1}, {3, 2})
    refute Spec.conforms?({3, &Integer.is_even/1}, {2, 2})
    refute Spec.conforms?({3, &Integer.is_even/1}, {3, 3})
  end

  test "validate/2 checks conformance to a spec" do
    assert {:ok, 3} = Spex.validate(3, 3)
    assert {:error, _} = Spex.validate(4, 3)
  end

  test "validate!/2 asserts conformance to a spec" do
    assert {:ok, 3} = Spex.validate(3, 3)
    assert_raise Spex.ValidationError, fn() -> Spex.validate!(4, 3) end
  end
end
