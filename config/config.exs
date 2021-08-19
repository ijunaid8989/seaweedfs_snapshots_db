import Config

config :seaweedfs_snapshots_db,
  ecto_repos: [Snapshots.Repo]

config :seaweedfs_snapshots_db, Snapshots.Repo,
  url: "postgres://localhost/evercam_snapshots",
  socket_options: [keepalive: true],
  timeout: 60_000,
  pool_size: 8,
  lazy: false
