defmodule ImageHub.Multimedia do
  import Ecto.Query, warn: false
  alias ImageHub.Repo
  alias ImageHub.Multimedia.Video
  alias ImageHub.Multimedia.Category
  alias ImageHub.Multimedia.Annotation
  alias ImageHub.Accounts.User

  def annotation_video(%User{id: user_id}, video_id, attrs) do
    %Annotation{user_id: user_id, video_id: video_id}
    |> Annotation.changeset(attrs)
    |> Repo.insert
  end

  def list_annotations(%Video{} = video, since_id \\ 0) do
    Repo.all(
      from a in Ecto.assoc(video, :annotations),
      where: a.id > ^since_id,
      order_by: [asc: a.at, asc: a.id],
      limit: 500,
      preload: [:user]
    )
  end

  def list_alphabetical_categories, do: \
    Category |> Category.alphabetical |> Repo.all

  def create_category(name) do
    %Category{name: name} |> Repo.insert!(on_conflict: :nothing)
  end

  def user_videos_query(query, %User{id: user_id}) do
    from(v in query, where: v.user_id == ^user_id, preload: [:user])
  end

  def list_user_videos(user) do
    Video
    |> user_videos_query(user)
    |> Repo.all()
  end

  def get_user_video!(user, id) do
    Video
    |> user_videos_query(user)
    |> Repo.get!(id)
  end

  def list_videos do
    Repo.all(from v in Video, preload: [:user])
  end

  def get_video!(id), do: Repo.get!(Video, id)

  def create_video(user, attrs \\ %{}) do
    %Video{}
    |> Video.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  def change_video(%Video{} = video) do
    Video.changeset(video, %{})
  end
end
