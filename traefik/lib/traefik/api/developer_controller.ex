defmodule Traefik.Api.DeveloperController do
  alias Traefik.Conn

  def index(%Conn{} = conn, _ \\ %{}) do
    json = Traefik.Organization.list_developerss() |> Jason.encode!()
    %Conn{conn | status: 200, response: json, content_type: "application/jsonn"}
  end
end
