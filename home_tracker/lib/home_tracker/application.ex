defmodule HomeTracker.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HomeTracker.Repo
    ]

    opts = [strategy: :one_for_one, name: HomeTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
