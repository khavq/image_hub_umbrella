defmodule ImageHub.Repo.Migrations.CreateUploads do
  use Ecto.Migration

  def change do
    create table(:uploads) do
      add :content_type, :string
      add :filename, :string
      add :hash, :string, size: 64
      add :size, :bigint

      timestamps()
    end

    create index(:uploads, [:hash])
  end
end
