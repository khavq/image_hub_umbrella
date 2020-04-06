defmodule ImageHub.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Accounts.User

  schema "credentials" do
    belongs_to :user, User
    field :password, :string
    field :role, :string

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:password, :role])
    |> validate_required([:password, :role])
  end
end
