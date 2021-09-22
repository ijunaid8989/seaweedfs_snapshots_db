defmodule Snapshots do
  import Ecto.Changeset
  import Ecto.Query

  require Logger

  use Ecto.Schema

  @primary_key {:snapshot_timestamp, :utc_datetime, []}
  schema "unset_snapshot" do
    field(:number, :integer, virtual: true)
  end

  def add_snapshots(query \\ __MODULE__, timestamps, camera_exid) do
    {camera_exid, query}
    |> Snapshots.Repo.insert_all(timestamps, on_conflict: :nothing)
  end

  def delete_snapshot(query \\ __MODULE__, timestamp, camera_exid) do
    {camera_exid, query}
    |> where([s], s.snapshot_timestamp == ^timestamp)
    |> Snapshots.Repo.delete_all()
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, [:snapshot_timestamp])
    |> validate_required([:snapshot_timestamp])
  end
end
