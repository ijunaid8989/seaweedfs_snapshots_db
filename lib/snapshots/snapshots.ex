defmodule Snapshots do
  import Ecto.Changeset
  import Ecto.Query

  require Logger

  use Ecto.Schema

  @primary_key {:snapshot_timestamp, :utc_datetime, []}
  schema "unset_snapshot" do
    field(:number, :integer, virtual: true)
  end

  def add_snapshot({:error, _reason}, _camera_exid), do: Logger.debug("NIL")

  def add_snapshot({:ok, datetime, _offset}, camera_exid) do
    %Snapshots{snapshot_timestamp: datetime}
    |> Ecto.put_meta(source: camera_exid)
    |> Snapshots.Repo.insert!(on_conflict: :nothing)
  end

  def delete_snapshot(query \\ __MODULE__, {:ok, timestamp, _offset}, camera_exid) do
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
