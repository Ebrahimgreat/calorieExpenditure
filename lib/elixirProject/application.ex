defmodule ElixirProject.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElixirProjectWeb.Telemetry,
      ElixirProject.Repo,
      {Ecto.Migrator,
        repos: Application.fetch_env!(:elixirProject, :ecto_repos),
        skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:elixirProject, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ElixirProject.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ElixirProject.Finch},
      # Start a worker by calling: ElixirProject.Worker.start_link(arg)
      # {ElixirProject.Worker, arg},
      # Start to serve requests, typically the last entry
      ElixirProjectWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirProject.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirProjectWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
