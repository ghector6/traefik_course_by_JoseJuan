defmodule Traefik.ParserTest do
  use ExUnit.Case

  alias Traefik.Parser

  test "parse a list of string headers into a map" do
    headers_string = ["Foo: Bar", "Date: 01/01/01"]
    headers = Parser.parse_headers(headers_string, %{})
    assert headers == %{"Foo" => "Bar", "Date" => "01/01/01"}
  end




end
