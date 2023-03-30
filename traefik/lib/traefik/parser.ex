defmodule Traefik.Parser do
  def parse(request) do
    [top , param_string] = String.split(request, "\n\n")

    [request_line | headers_string] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    params = String.trim(param_string) |> URI.decode_query()

    headers = parse_headers(headers_string, %{} )

    %Traefik.Conn{
      method: method,
      path: path,
      response: "",
      status: nil,
      params: params,
      headers: headers
    }
  end

    def parse_headers([], headers), do: headers

    def parse_headers([headers_string | rest], headers) do
      [key_header, value_header] = String.split(headers_string, ": ")
      headers  = Map.put(headers, key_header, value_header)
      parse_headers(rest, headers )
    end
end
