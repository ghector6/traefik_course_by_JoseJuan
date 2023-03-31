defmodule Traefik.DeveloperController do
  alias Traefik.Conn
  alias Traefik.Developer

  def index(%Conn{} = conn) do
    response =
      Traefik.Organization.list_developers()
      |> Enum.filter(&Developer.filter_male_female/1)
      |> Enum.sort(&Developer.sort_by_lastname/2)
      |> Enum.take(10)
      |> Enum.map(&Developer.format_developer_item/1)
    %Conn{conn | status: 200, response: "<ul>#{response}</ul>"}
  end

  def show(conn, _params) do
    %Conn{conn | status: 200, response: "ONE DEVELOPER"}
  end
end
