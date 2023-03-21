defmodule Traefik.Handler do 
  def handle(request) do
    "Hola mundo #{request}"
    request
    |> parse()
    |> route()
    |> format_response
  end

  def parse(_request) do
    [method, path, _] = 
    request 
    |> String.split("\n") 
    |> List.first() 
    |>String.split(" ")

    %{method: "GET", path: "/developers", response: "Hello Devs"}
  end

  def route(_conn) do
    _conn = %{method: "GET", path: "/", response: "Hello Devs"}
  end

  def format_response(_conn) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 14

    Hello Devs
    

    @hgector6, @makingdevs, @eln
    """
  end
end

request = """
GET / developers HTTP/1.1
Host: makingdevs.com
User-Agent: Mybrowser/0.1
Accept: */*

"""
response =  Traefik.Handler.handle(request)
IO.puts(response)
