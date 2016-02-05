defmodule Phrum.ScrumController do
  use Phrum.Web, :controller

  def index(conn, _params) do
    scrums = Phrum.Repo.all(Phrum.Scrum)
    render conn, "index.html", scrums: scrums
  end
end
