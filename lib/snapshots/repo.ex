defmodule Snapshots.Repo do
  use Ecto.Repo,
    otp_app: :seaweedfs_snapshots_db,
    adapter: Ecto.Adapters.Postgres
end
