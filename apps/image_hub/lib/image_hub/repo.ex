defmodule ImageHub.Repo do
  use Ecto.Repo,
    otp_app: :image_hub,
    adapter: Ecto.Adapters.Postgres
end
