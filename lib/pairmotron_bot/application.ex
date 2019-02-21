defmodule PairmotronBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      PairmotronBot.Repo,
      # Start the endpoint when the application starts
      PairmotronBotWeb.Endpoint
      # Starts a worker by calling: PairmotronBot.Worker.start_link(arg)
      # {PairmotronBot.Worker, arg},
    ]

    slack_api_key = System.get_env("SLACK_PAIRMOTRON_BOT_USER_ACCESS_TOKEN")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PairmotronBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PairmotronBotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
