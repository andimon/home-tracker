defmodule HomeTrackerUi.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HomeTrackerUiWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:home_tracker_ui, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: HomeTrackerUi.PubSub},
      HomeTrackerUiWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: HomeTrackerUi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    HomeTrackerUiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
