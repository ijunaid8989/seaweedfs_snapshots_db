defmodule SeaweedfsSupervisor do
  use DynamicSupervisor
  require Logger

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_init_arg) do
    Task.start_link(&initiate_workers/0)
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_worker(nil), do: :noop

  def start_worker(camera) do
    DynamicSupervisor.start_child(__MODULE__, {SeaweedfsWorker, camera})
  end

  def initiate_workers do
    Logger.info("Initiate seaweedfs workers.")

    {:ok, result} =
      Snapshots.Repo.query(
        "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema'"
      )

    Enum.map(result.rows, fn camera ->
      id = List.first(camera)

      start_worker(%{
        id: String.to_atom(id),
        camera: id,
        timestamps: []
      })
    end)
  end
end
