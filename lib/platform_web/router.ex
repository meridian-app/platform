defmodule PlatformWeb.Router do
  use PlatformWeb, :router

  import PlatformWeb.UsersAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PlatformWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_users
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PlatformWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", PlatformWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:platform, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PlatformWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", PlatformWeb do
    pipe_through [:browser, :redirect_if_users_is_authenticated]

    live_session :redirect_if_users_is_authenticated,
      on_mount: [{PlatformWeb.UsersAuth, :redirect_if_users_is_authenticated}] do
      live "/identity/signup", UsersRegistrationLive, :new
      live "/identity/login", UsersLoginLive, :new
      live "/identity/reset_password", UsersForgotPasswordLive, :new
      live "/identity/reset_password/:token", UsersResetPasswordLive, :edit
    end

    post "/identity/login", UsersSessionController, :create
  end

  scope "/", PlatformWeb do
    pipe_through [:browser, :require_authenticated_users]

    live_session :require_authenticated_users,
      on_mount: [{PlatformWeb.UsersAuth, :ensure_authenticated}] do
      live "/identity/settings", UsersSettingsLive, :edit
      live "/identity/settings/confirm_email/:token", UsersSettingsLive, :confirm_email
    end
  end

  scope "/", PlatformWeb do
    pipe_through [:browser]

    delete "/identity/logout", UsersSessionController, :delete

    live_session :current_users,
      on_mount: [{PlatformWeb.UsersAuth, :mount_current_users}] do
      live "/identity/confirm/:token", UsersConfirmationLive, :edit
      live "/identity/confirm", UsersConfirmationInstructionsLive, :new
    end
  end
end
