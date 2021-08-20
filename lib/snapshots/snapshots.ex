defmodule Snapshots do
  import Ecto.Changeset

  use Ecto.Schema

  @primary_key {:snapshot_timestamp, :utc_datetime, []}
  schema "unset_snapshot" do
    field(:number, :integer, virtual: true)
  end

  def add_snapshot(camera_exid, datetime) do
    %Snapshots{snapshot_timestamp: datetime}
    |> Ecto.put_meta(source: camera_exid)
    |> Snapshots.Repo.insert(on_conflict: :nothing)
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, [:snapshot_timestamp])
    |> validate_required([:snapshot_timestamp])
  end
end
