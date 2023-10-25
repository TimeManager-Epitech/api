defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TimeManagerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TimeManagerWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api

    scope "/users" do
      get "/", UserController, :show
      post "/", UserController, :create

      scope "/:user_id" do
        get "/", UserController, :show
        put "/", UserController, :update
        delete "/", UserController, :delete
      end
    end

    scope "/working_times" do
      scope "/:id" do
        put "/", WorkingTimeController, :update
        delete "/", WorkingTimeController, :delete
      end
      scope "/:user_id" do
        get "/", WorkingTimeController, :index
        get "/:id", WorkingTimeController, :show
        post "/", WorkingTimeController, :create
      end
    end

    scope "/clocks/:user_id" do
      get "/", ClockController, :show
      post "/", ClockController, :create
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", TimeManagerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:time_manager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
