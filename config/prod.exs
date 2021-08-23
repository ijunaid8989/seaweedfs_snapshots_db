use Mix.Config

config :seaweedfs_snapshots_db, Snapshots.Repo,
  url: System.get_env("SNAPSHOT_DATABASE_URL"),
  socket_options: [keepalive: true],
  timeout: 60_000,
  pool_size: 8,
  lazy: false,
  ssl: true
