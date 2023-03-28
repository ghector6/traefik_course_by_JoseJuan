defmodule Traefik.Parser do
  def parse(request) do
    [top , param_string] = String.split(request, "\n\n")

    [request_line | _headers] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    params = String.trim(params_string) |> URI.decode_query()

    %Traefik.Conn{
      method: method,
      path: path,
      response: "",
      staus: nil,
      params: params
    }

    %Traefik.Conn{method: method, path: path,  response: "", status: nil}
  end
end
