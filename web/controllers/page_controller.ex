defmodule Phrum.PageController do
  use Phrum.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
