defmodule Traefik.Handler do
  @moduledoc """
  Handles the request in Traefik WebServer in a simple way.
  """

  @pages_path Path.expand("../../pages", __DIR__)

  import Traefik.Parser, only: [parse: 1]
  import Traefik.Plugs, only: [rewrite_path: 1, track: 1, log: 1]

  alias Traefik.Conn


  @doc "Transforms the request into a response when it is called"
  def handle(request) do
    request
    |> parse()
    |> rewrite_path()
    |> log()
    |> route()
    |> log()
    |> track()
    |> format_response()
  end

  def route(%Conn{method: "GET", path: "/secret-projects"} = conn) do
    %Conn{conn | status: 200, response: "Learning OTP, LiveView"}
  end

  def route(%Conn{method: "GET", path: "/developers"} = conn) do
    %Conn{conn | status: 200, response: "Hello person"}
  end

  def route(%Conn{method: "GET", path: "/developers/" <> id} = conn) do
    %Conn{conn | status: 200, response: "Hello person #{id}"}
  end

  def route(%Conn{method: "GET", path: "/projects"} = conn) do
    %Conn{conn | status: 200, response: "Traefik, Agora, Codebreaker"}
  end

  def route(%Conn{method: "GET", path: "/makingdevs"} = conn) do
    Traefik.DeveloperController.index(conn)
  end

  def route(%Conn{method: "GET", path: "/makingdevs/" <> id} = conn) do
    params = conn.params |> Map.put("id", id)
    Traefik.DeveloperController.show(conn, params)
  end

  def route(%Conn{method: "GET", path: "/about"} = conn) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conn)
  end

  def route(%Conn{method: "POST", path: "/developers"} = conn) do
    Traefik.DeveloperController.create(conn, conn.params)
  end

  def route(%Conn{method: _, path: path} = conn) do
    %Conn{conn | status: 404, response: "No #{path} found"}
  end

  def handle_file({:ok, content}, %Conn{} = conn) do
    %Conn{conn | status: 200, response: content}
  end

  def handle_file({:error, :enoent}, %Conn{} = conn) do
    %Conn{conn | status: 404, response: "File not Found!!"}
  end

  def handle_file({:error, reason}, %Conn{} = conn) do
    %Conn{conn | status: 500, response: "File error: #{reason}"}
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

  def format_response(%Conn{} = conn) do
    """
    HTTP/1.1 #{Conn.full_status(conn)}
    Content-Type: text/html
    Content-Length: #{String.length(conn.response)}

    #{conn.response}

    @ghector6, @makingdevs, @eln
    """
  end
end

request_1 = """
GET /developers HTTP/1.1
Host: makingdevs.com
User-Agent: Mybrowser/0.1
Accept: */*

"""

IO.puts(Traefik.Handler.handle(request_1))

request_2 = """
GET /projects HTTP/1.1
Host: makingdevs.com
User-Agent: Mybrowser/0.1
Accept: */*

"""
IO.puts(Traefik.Handler.handle(request_2))


request_3 = """
GET /developers/1 HTTP/1.1
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

request_7 = """
POST /developers HTTP/1.1
Host: makingdevs.com
User-Agent: MyBrowser/0.1
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 66

name=Hector&lastname=Garcia&email=hector@makingdevs.com
"""

IO.puts(Traefik.Handler.handle(request_7))

request_8 = """
GET /makingdevs HTTP/1.1
Host: makingdevs.com
User-Agent: MyBrowser/0.1
Accept: */*

"""


IO.puts(Traefik.Handler.handle(request_8))

request_9 = """
GET /makingdevs/3 HTTP/1.1
Host: makingdevs.com
User-Agent: MyBrowser/0.1
Accept: */*

"""


IO.puts(Traefik.Handler.handle(request_9))





