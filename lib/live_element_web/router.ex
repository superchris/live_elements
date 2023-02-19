defmodule LiveElementWeb.Router do
  alias LiveElementWeb.DemoLive
  use LiveElementWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LiveElementWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveElementWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/demo", Demo.DemoLive
    live "/people", PersonLive.Index, :index
    live "/people/new", PersonLive.Index, :new
    live "/people/:id/edit", PersonLive.Index, :edit

    live "/people/:id", PersonLive.Show, :show
    live "/people/:id/show/edit", PersonLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveElementWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
