defmodule Papelito do
  use Application
  require Logger

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec
    Logger.info "Starting Papelito application"
    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Papelito.Repo, []),
      # Start the endpoint when the application starts
      supervisor(Papelito.Endpoint, []),
      # Start your own worker by calling: Papelito.Worker.start_link(arg1, arg2, arg3)
      # worker(Papelito.Worker, [arg1, arg2, arg3]),
      supervisor(Papelito.Supervisor.Root, [:ok])
    ]

    # Game persistency
    Papelito.Storage.setup
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Papelito.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Papelito.Endpoint.config_change(changed, removed)
    :ok
  end
end
