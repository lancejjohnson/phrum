defmodule Phrum.Auth do

  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  # This will make `repo` available within the controller when used as a
  # module plug.
  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  # Allow this to be used as a module plug
  # Plug Phrum.Auth
  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    # Elixir evaluates && similar to Ruby. If the left side of the condition
    # is falsey, it returns that value. Otherwise it evals the right side. If
    # that returns falsey, that gets returned. Otherwise the truthy value of
    # the right side is returned.
    # So, user will either be the user from the repo or it will be falsey because
    # either the user_id wasn't found in the session, or the user could not
    # be found in the repo.
    user = user_id && repo.get(Rumbl.User, user_id)
    # Make @current_user in the conn equal to the result of the lookup,
    # either falsey or the user from the repo.
    assign(conn, :current_user, user)
  end

  # Get the repo from the opts.
  # Try to find the user from the repo.
  # Check to see if the user's password hash matches that of the given_password.
  # If it does, login the user.
  # If it doesn't, send back an error.
  def login_by_username_and_password(conn, username, given_password, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(Phrum.User, username: username)

    cond do
      # If I have both a user and the password checks out
      user && checkpw(given_password, user.password_hash) ->
        {:ok, login(conn, user)}
      # If I have a user but the password didn't check out
      user ->
        {:error, :unauthorized, conn}
      # Anything else
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  # Add user to the conn by assigning them to the :current_user key
  # Add user's id to the conn's session cookies by assinging it to the :user_id key.
  # Configure the connection's session so that it generates a new session id for
  # the cookie.
  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  # Drop the session from the connection.
  # A session cookie will not be included in the response.
  def logout(conn) do
    configure_session(conn, drop: true)
  end
end
