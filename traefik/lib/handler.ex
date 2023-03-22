defmodule Traefik.Handler do 
  def handle(request) do
    request
    |> parse()
    |> route()
    |> format_response
  end

  def parse(request) do
    [method, path, _] = 
      request 
      |> String.split("\n") 
      |> List.first() 
      |> String.split(" ")

    %{method: "GET", path: path,  response: "Hello Devs"}
  end

  def route(conn) do
    %{conn | response: "Hello MakingDevs"}
  end

  def format_response(conn) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(conn.response)}

    #{conn.response} 

    @hgector6, @makingdevs, @eln
    """
  end
end

request = """
GET /developers HTTP/1.1
Host: makingdevs.com
User-Agent: Mybrowser/0.1
Accept: */*

"""
response =  Traefik.Handler.handle(request)
IO.puts(response)
