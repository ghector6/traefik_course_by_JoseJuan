defmodule Traefik.Handler do 
  @moduledoc """
  Handles the request in Traefik WebServer in a simple way.
  """

  @pages_path Path.expand("../../pages", __DIR__)

  import Traefik.Parser, only: [parse: 1]
  import Traefik.Plugs, only: [rewrite_path: 1, track: 1, log: 1]


  @doc """
  Transforms the request into a response when it is called
  """
  def handle(request) do
    request
    |> parse()
    |> rewrite_path()
    |> log()
    |> route()
    |> track()
    |> format_response()
  end

  def route(conn) do
    route(conn, conn.method, conn.path)
  end

  def route(conn, "GET", "/hello") do
    %{conn | status: 200, response: "Hello person"}
  end

  def route(conn, "GET", "/hello/" <> id) do
    %{conn | status: 200, response: "Hello person #{id}"}
  end

  def route(conn, "GET", "/developers"  ) do
    %{conn | status: 200, response: "Hello Making Devs "}
  end

  def route(conn, "GET", "/secret-projects") do
    %{conn | status: 200, response: "Learning OTP, LiveView"}
  end

  def route(conn, "GET", "/about") do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conn)
  end

  def route(conn, _, path  ) do
    %{conn | status: 404, response: "No #{path} found"}
  end

  def handle_file({:ok, content}, conn) do
    %{conn | status: 200, response: content}
  end

  def handle_file({:error, :enoent}, conn) do
    %{conn | status: 404, response: "File not Found!!"}
  end

  def handle_file({:error, reason}, conn) do
    %{conn | status: 500, response: "File error: #{reason}"}
  end



#  def route(conn, "GET", "/about") do 
#    file_path = 
#      Path.expand("../../pages", __DIR__)
#      |> Path.join("about.html")
#
#    case File.read(file_path) do
#      {:ok, content} ->
#        %{conn | status: 200, response: content}
#
#      {:error, :enoent} ->
#        %{conn | status: 404, response: "File not found!"}
#
#      {:error, reason} ->
#        %{conn | status: 500, response: " File error: #{reason}"}
#    end
#  end

  def format_response(conn) do
    """
    HTTP/1.1 #{conn.status} #{code_status(conn.status)}  
    Content-Type: text/html
    Content-Length: #{String.length(conn.response)}

    #{conn.response} 

    @ghector6, @makingdevs, @eln
    """
  end

  defp code_status(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }
    |> Map.get(code, "Not Found")
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


request_3 = """
GET /hello/1 HTTP/1.1
Host: makingdevs.com
User-Agent: Mybrowser/0.1
Accept: */*

"""
IO.puts(Traefik.Handler.handle(request_3))

request_4 = """
GET /bugme HTTP/1.1
Host: makingdevs.com
User-Agent: Mybrowser/0.1
Accept: */*

"""
IO.puts(Traefik.Handler.handle(request_4))

request_5 = """
GET /internal-projects HTTP/1.1
Host: makingdevs.com
User-Agent: Mybrowser/0.1
Accept: */*

"""
IO.puts(Traefik.Handler.handle(request_5))

request_6 = """
GET /about HTTP/1.1
Host: makingdevs.com
User-Agent: MyBrowser/0.1
Accept: */*

"""
IO.puts(Traefik.Handler.handle(request_6))
