use Mix.Config

config :info_sys, :wolfram,
  app_id: "some_app_id",
  http_client: InfoSys.Test.HTTPClient

# Configure your database
config :image_hub, ImageHub.Repo,
  username: "postgres",
  password: "postgres",
  database: "image_hub_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :image_hub_web, ImageHubWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
