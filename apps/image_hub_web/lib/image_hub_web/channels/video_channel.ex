defmodule ImageHubWeb.VideoChannel do
  use ImageHubWeb, :channel
  alias ImageHub.Multimedia

  def join("videos:" <> video_id, params, socket) do
    send(self(), :after_join)
    last_seen_id = params["last_seen_id"] || 0
    video_id = String.to_integer(video_id)
    annotations =
      Multimedia.get_video!(video_id)
      |> Multimedia.list_annotations(last_seen_id)
      |> Phoenix.View.render_many(ImageHubWeb.AnnotationView, "annotation.json")

    {:ok, %{annotations: annotations}, assign(socket, :video_id, video_id)}
  end

  def handle_in(event, params, socket) do
    user = current_user(socket.assigns[:current_user])
    handle_in(event, params, user, socket)
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", ImageHubWeb.Presence.list(socket))
    {:ok, _} = ImageHubWeb.Presence.track(
      socket,
      socket.assigns.current_user,
      %{device: "browser"})

    {:noreply, socket}
  end

  def handle_in("new_annotation", params, user, socket) do
    case ImageHub.Multimedia.annotation_video(user, socket.assigns.video_id, params) do
      {:ok, annotation} ->
        broadcast_annotation(user, annotation, socket)
        Task.start(fn -> compute_additional_info(annotation, socket) end)

        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{error: changeset}}, socket}
    end

    {:reply, :ok, socket}
  end

  defp broadcast_annotation(user, annotation, socket) do
    broadcast!(socket, "new_annotation", %{
      id: annotation.id,
      user: ImageHubWeb.UserView.render("user.json", %{user: user}),
      body: annotation.body,
      at: annotation.at
    })
  end

  def compute_additional_info(annotation, socket) do
    for result <- InfoSys.compute(annotation.body, limit: 1, timeout: 10_000) do
      backend_user = ImageHub.Accounts.get_user_by(email: "wolfram@imh.com")
      attrs = %{at: annotation.at, body: result.text }

      case ImageHub.Multimedia.annotation_video(backend_user, annotation.video_id, attrs) do
        {:ok, backend_annotation} ->
          broadcast_annotation(backend_user, backend_annotation, socket)
        _ -> :error
      end
    end
  end

  defp current_user(id) do
    ImageHub.Accounts.get_user!(id)
  end
end
