defmodule TeteWeb.PageController do
  use TeteWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
