# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

wolfram_app_id = System.get_env("WOLFRAM_APP_ID") || raise "MISSING WOLFRAM APP ID"
config :info_sys, :wolfram, app_id: wolfram_app_id

config :image_hub,
  documents_upload_directory: System.get_env("DOCUMENTS_UPLOADS_DIRECTORY")

config :ueberauth, Ueberauth,
  providers: [ google: {Ueberauth.Strategy.Google, []} ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  #client_id: System.get_env("GOOGLE_CLIENT_ID"),
  #client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
  #redirect_uri: System.get_env("GOOGLE_REDIRECT_URI")

  client_id: {System, :get_env, ["UEBERAUTH_GOOGLE_CLIENT_ID"]},
  client_secret: {System, :get_env, ["UEBERAUTH_GOOGLE_CLIENT_SECRET"]},
  redirect_uri: {System, :get_env, ["UEBERAUTH_GOOGLE_REDIRECT_URI"]}

config :image_hub, ImageHub.Accounts.Guardian,
  issuer: "image_hub",
  secret_key: {System, :get_env, ["GUARDIAN_SECRET_KEY"]}
# Configure Mix tasks and generators
config :image_hub,
  ecto_repos: [ImageHub.Repo]

config :image_hub_web,
  ecto_repos: [ImageHub.Repo],
  generators: [context_app: :image_hub]

# Configures the endpoint
config :image_hub_web, ImageHubWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ySEvb0QT+YYY1ATuovGSxQr833q+bynY26/pit1iGuvc6XnSBt5UZxNOICWw2Omi",
  render_errors: [view: ImageHubWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ImageHubWeb.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "z7e3fPUj"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
