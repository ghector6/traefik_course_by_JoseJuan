defmodule Hello do
  def hello(name) do
    "Qué onda #{name} ?"

  end
end

IO.puts(Hello.hello("Hector"))
