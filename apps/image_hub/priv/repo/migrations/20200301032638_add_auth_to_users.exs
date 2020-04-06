defmodule ImageHub.Repo.Migrations.AddAuthToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :auth_id, :string
      add :auth_provider, :string
    end

    create unique_index(:users, [:email])
  end
end
