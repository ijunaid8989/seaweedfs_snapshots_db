defmodule SeaweedfsWorker do
  use GenServer

  require Logger

  def start_link(opts) do
    {id, opts} = Map.pop!(opts, :id)
    GenServer.start_link(__MODULE__, opts, name: id)
  end

  def init(state) do
    Process.flag(:trap_exit, true)
    {:ok, state}
  end

  def get_state(pid) do
    GenServer.call(pid, :get)
  end

  def update_snapshots(pid, timestamp) do
    snapshots = GenServer.call(pid, {:update_snapshots, timestamp})

    if length(snapshots) >= 1 do
      GenServer.call(pid, :insert_snapshots)
    end
  end

  def delete_snapshot(pid, timestamp) do
    GenServer.cast(pid, {:delete_snapshot, timestamp})
  end

  def handle_call({:update_snapshots, timestamp}, _from, state) do
    new_state =
      Map.replace(state, :timestamps, [%{snapshot_timestamp: timestamp} | state.timestamps])

    {:reply, new_state.timestamps, new_state}
  end

  def handle_call(:get, _from, state),
    do: {:reply, state, state}

  def handle_call(:insert_snapshots, _from, state) do
    Snapshots.add_snapshots(state.timestamps, state.camera)
    new_state = Map.replace(state, :timestamps, [])
    {:reply, state, new_state}
  end

  def handle_cast({:delete_snapshot, timestamp}, state) do
    Snapshots.delete_snapshot(timestamp, state.camera)
    {:noreply, state}
  end
end
