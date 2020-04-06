defmodule ImageHubWeb.Router do
  use ImageHubWeb, :router

  pipeline :auth do
    plug ImageHub.Accounts.Pipeline
    plug :put_user_token
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", ImageHubWeb do
    pipe_through([:browser])

    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
    post("/:provider/callback", AuthController, :callback)
    post("/logout", AuthController, :delete)
  end

  scope "/", ImageHubWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index


    # session
    get  "/login",  SessionController, :new
    get  "/logout", SessionController, :logout
    post "/login",  SessionController, :login
    get "/sign_up", UserController, :new
    post "/users", UserController, :create
    get "/videos", VideoController, :index
    get "/watch/:id", WatchController, :show
  end

  scope "/", ImageHubWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/protected", PageController, :protected
    resources "/users", UserController
    resources "/uploads", UploadController
    resources "/videos", VideoController
  end

  defp put_user_token(conn, _) do
    if current_user = conn.assigns[:current_user] do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end
  # Other scopes may use custom stacks.
  # scope "/api", ImageHubWeb do
  #   pipe_through :api
  # end
end
