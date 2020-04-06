defmodule ImageHubWeb.UploadController do
  use ImageHubWeb, :controller

  alias ImageHub.Documents

  def index(conn, _params) do
    uploads = Documents.list_uploads()
    render(conn, "index.html", uploads: uploads)
  end

  def new(conn, _params) do
    #changeset = Documents.change_upload(%Upload{})
    render(conn, "new.html") #, changeset: changeset)
  end

  def create(conn, %{"upload" => %Plug.Upload{} = upload}) do
    case Documents.create_upload_from_plug_upload(upload) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Upload created successfully.")
        |> redirect(to: Routes.upload_path(conn, :index))

      {:error, reason} ->
        put_flash(conn, :error, "Upload failed #{inspect(reason)}.")
        render(conn, "new.html")
    end
  end

  def show(conn, %{"id" => id}) do
    upload = Documents.get_upload!(id)
    render(conn, "show.html", upload: upload)
  end

  def edit(conn, %{"id" => id}) do
    upload = Documents.get_upload!(id)
    changeset = Documents.change_upload(upload)
    render(conn, "edit.html", upload: upload, changeset: changeset)
  end

  def update(conn, %{"id" => id, "upload" => upload_params}) do
    upload = Documents.get_upload!(id)

    case Documents.update_upload(upload, upload_params) do
      {:ok, upload} ->
        conn
        |> put_flash(:info, "Upload updated successfully.")
        |> redirect(to: Routes.upload_path(conn, :show, upload))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", upload: upload, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    upload = Documents.get_upload!(id)
    {:ok, _upload} = Documents.delete_upload(upload)

    conn
    |> put_flash(:info, "Upload deleted successfully.")
    |> redirect(to: Routes.upload_path(conn, :index))
  end
end
