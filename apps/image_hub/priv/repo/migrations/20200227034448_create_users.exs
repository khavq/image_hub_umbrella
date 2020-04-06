defmodule ImageHub.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :phone_number, :string
      add :name, :string
      add :avatar_url, :string

      timestamps()
    end

  end
end
