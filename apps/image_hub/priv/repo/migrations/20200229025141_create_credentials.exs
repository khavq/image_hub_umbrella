defmodule ImageHub.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :password, :string
      add :role, :string

      timestamps()
    end

  end
end
