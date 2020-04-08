defmodule ImageHubWeb.TestHelpers do

  defp default_user() do
    %{
      name: "Some User",
      email: "user#{System.unique_integer([:positive])}@imh.com",
      password: "supersecret"
    }
  end

  def insert_user(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(default_user())
      |> ImageHub.Accounts.create_user

    user
  end

  defp default_video() do
    %{
      url: "test@example.com",
      description: "a video",
      body: "body"
    }
  end

  def insert_video(user, attrs \\ %{}) do
    video_fields = Enum.into(attrs, default_video())
    {:ok, video} = ImageHub.Multimedia.create_video(user, video_fields)
    video
  end

  def login(%{conn: conn, login_as: email}) do
    user = insert_user(email: email)

    {Plug.Conn.assign(conn, :current_user, user), user}
  end
  def login(%{conn: conn}), do: {conn, :logged_out}
end
