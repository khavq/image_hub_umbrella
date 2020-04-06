defmodule ImageHub.Repo.Migrations.AddPasswordToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password, :string, null: false, default: ""
    end
  end
end
