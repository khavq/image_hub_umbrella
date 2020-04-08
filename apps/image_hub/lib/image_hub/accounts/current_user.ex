defmodule ImageHub.Accounts.CurrentUser do
  #import Plug.Conn
  #import Guardian.Plug
  def init(opts), do: opts
  def call(conn, _opts) do
    current_user = Guardian.Plug.current_resource(conn)
    Plug.Conn.assign(conn, :current_user, current_user)
  end
end
