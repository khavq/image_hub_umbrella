defmodule Tete.Repo do
  use Ecto.Repo,
    otp_app: :tete,
    adapter: Ecto.Adapters.Postgres
end
