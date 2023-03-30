defmodule Traefik.Organization do
  @csv_file Path.expand("../..", __DIR__)

  def list_developer() do
    @csv_file
    |> Path.join("MOCK_DATA.csv")
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ","))
  end

end
