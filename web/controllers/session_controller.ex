defmodule Phrum.SessionController do
  use Phrum.Web, :controller

  alias Phrum.Auth
  alias Phrum.Repo

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"username" => username, "password" => pw}}) do
    # Try to login with the auth service
    case Auth.login_by_username_and_pw(conn, username, pw, repo: Repo) do
      # If the struct returned by the Auth fn matches :ok
      {:ok, conn} ->
        conn
        # Add a flash message to the connection
        |> put_flash(:info, "Welcome back #{username}")
        # Redirect to the home page
        |> redirect(to: page_path(conn, :index))
      # If the struct returned by the Auth fn matches :error
      {:error, _reason, conn} ->
        conn
        # Add a flash message to the connection
        |> put_flash(:error, "Invalid username/password combination")
        # Re-render the session form
        |> render("new.html")
    end
  end

  def delete(conn) do
    conn
    |> Auth.logout()
    |> put_flash(:info, "See ya later!")
    |> redirect(to: page_path(conn, :index))
  end

end
