defmodule HomeTracker.Repo do
  use Ecto.Repo,
    otp_app: :home_tracker,
    adapter: Ecto.Adapters.SQLite3
end
