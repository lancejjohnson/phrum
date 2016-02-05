defmodule Phrum.Router do
  use Phrum.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Phrum do
    pipe_through :browser # Use the default browser stack

    get "/scrum", ScrumController, :index
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Phrum do
  #   pipe_through :api
  # end
end
