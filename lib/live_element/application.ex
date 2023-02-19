defmodule LiveElement.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      LiveElement.Repo,
      # Start the Telemetry supervisor
      LiveElementWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveElement.PubSub},
      # Start the Endpoint (http/https)
      LiveElementWeb.Endpoint
      # Start a worker by calling: LiveElement.Worker.start_link(arg)
      # {LiveElement.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveElement.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveElementWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
