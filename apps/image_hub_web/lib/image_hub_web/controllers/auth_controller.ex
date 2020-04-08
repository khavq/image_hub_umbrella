defmodule ImageHubWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use ImageHubWeb, :controller
  plug(Ueberauth)

  alias Ueberauth.Strategy.Helpers
  alias ImageHub.Accounts.Guardian

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> redirect(to: "/login")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/login")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        #|> put_session(:current_user, user)
        |> Guardian.Plug.sign_in(user)
        #|> configure_session(renew: true)
        |> redirect(to: "/users")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/login")
    end
  end
end
