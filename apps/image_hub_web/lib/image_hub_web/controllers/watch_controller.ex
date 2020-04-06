defmodule ImageHubWeb.WatchController do
  use ImageHubWeb, :controller
  alias ImageHub.Multimedia

  def show(conn, %{"id" => id}) do
    video = Multimedia.get_video!(id)
    render(conn, "show.html", video: video)
  end
end
