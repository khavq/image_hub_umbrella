defmodule ImageHub.Multimedia.Annotation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "annotations" do
    field :at, :integer
    field :body, :string
    belongs_to :user, ImageHub.Accounts.User
    belongs_to :video, ImageHub.Multimedia.Video

    timestamps()
  end

  @doc false
  def changeset(annotation, attrs) do
    annotation
    |> cast(attrs, [:body, :at])
    |> validate_required([:body, :at])
  end
end