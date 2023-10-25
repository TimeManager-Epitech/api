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

    get "/users", UserController, :show
    get "/users/:user_id", UserController, :show
    post "/users", UserController, :create
    put "/users/:user_id", UserController, :update
    delete "/users/:user_id", UserController, :delete

    get "/working_times/:user_id", WorkingTimeController, :index
    get "/working_times/:user_id/:id", WorkingTimeController, :show
    post "/working_times/:user_id", WorkingTimeController, :create
    put "/working_times/:id", WorkingTimeController, :update
    delete "/working_times/:id", WorkingTimeController, :delete
    
    get "/clocks/:user_id", ClockController, :show
    post "/clocks/:user_id", ClockController, :create

    resources "/clocks", ClockController, except: [:new, :edit]
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
