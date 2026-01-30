import Config

config :home_tracker,
  ecto_repos: [HomeTracker.Repo]

config :home_tracker, HomeTracker.Repo,
  database:
    System.get_env("DATABASE_PATH") || raise("DATABASE_PATH environment variable is not set"),
  pool_size: 5
