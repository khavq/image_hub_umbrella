defmodule ImageHub.Accounts.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :image_hub,
    error_handler: ImageHub.Accounts.ErrorHandler,
    module: ImageHub.Accounts.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
  plug ImageHub.Accounts.CurrentUser
end
