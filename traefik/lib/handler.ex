defmodule Traefik.Handler do 
  def handle(request) do
    request
    |> parse()
    |> route()
    |> format_response()
  end

  def parse(request) do
    [method, path, _] = 
      request 
      |> String.split("\n") 
      |> List.first() 
      |> String.split(" ")

    %{method: method, path: path,  response: ""}
  end


  def route(conn) do
    route(conn, conn.method, conn.path)
  end

  def route(conn, "GET", "/hello") do
    %{conn | response: "Hello person"}
  end

  def route(conn, "GET", "/developers"  ) do
    %{conn | response: "Hello Making Devs "}
  end

  def format_response(conn) do
    """
    HTTP/1.1 200 OK 
    Content-Type: text/html
    Content-Length: #{String.length(conn.response)}

    #{conn.response} 

    @ghector6, @makingdevs, @eln
    """
  end
end

request_1 = """
GET /hello HTTP/1.1
Host: makingdevs.com
User-Agent: Mybrowser/0.1
Accept: */*

"""

IO.puts(Traefik.Handler.handle(request_1))

request_2 = """
GET /developers HTTP/1.1
Host: makingdevs.com
User-Agent: Mybrowser/0.1
Accept: */*

"""
IO.puts(Traefik.Handler.handle(request_2))


#request_3 = """
#GET /hello/1 HTTP/1.1
#Host: makingdevs.com
#User-Agent: Mybrowser/0.1
#Accept: */*

#"""
#IO.puts(Traefik.Handler.handle(request_3))

request_4 = """
GET /bugme HTTP/1.1
Host: makingdevs.com
User-Agent: Mybrowser/0.1
Accept: */*

"""
IO.puts(Traefik.Handler.handle(request_4))



