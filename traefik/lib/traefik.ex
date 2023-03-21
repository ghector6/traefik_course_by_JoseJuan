defmodule Traefik do
  def hello(name) do
    "Hello, #{name}"
  end
end

IO.puts(Traefik.hello("Hector"))
