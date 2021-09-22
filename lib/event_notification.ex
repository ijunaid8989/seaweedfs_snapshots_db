defmodule EventNotification do
  require Logger

  @url_format ~r[/(?<camera_exid>.*)/snapshots/recordings/(?<year>\d{4})/(?<month>\d{1,2})/(?<day>\d{1,2})/(?<hour>\d{1,2})/(?<minute>\d{2})_(?<seconds>\d{2})_(?<milliseconds>\d{3})\.jpg]

  def upcoming_events(nil) do
    Logger.debug("NIL")
  end

  ##########
  # INSERT #
  ##########
  def upcoming_events(_message, %FilerPb.EventNotification{
        new_entry: %FilerPb.Entry{name: file_name},
        old_entry: nil,
        new_parent_path: path
      }) do
    with {:ok, timestamp, camera_exid} <- url_to_timestamp(path, file_name),
         pid when not is_nil(pid) <- find_worker(camera_exid),
         {:ok, timestamp, _offset} <- DateTime.from_iso8601(timestamp) do
      SeaweedfsWorker.update_snapshots(pid, timestamp)
    else
      _ ->
        :noop
    end
  end

  ##########
  # UPDATE #
  ##########
  def upcoming_events(_message, %FilerPb.EventNotification{
        new_entry: %FilerPb.Entry{name: new_file_name},
        old_entry: %FilerPb.Entry{name: old_file_name},
        new_parent_path: path
      }), do: :noop

  ##########
  # DELETE #
  ##########
  def upcoming_events(%Broadway.Message{metadata: %{key: path}}, %FilerPb.EventNotification{
        new_entry: nil,
        old_entry: %FilerPb.Entry{name: file_name}
      }) do
    with {:ok, timestamp, camera_exid} <- url_to_timestamp(path, file_name),
         pid when not is_nil(pid) <- find_worker(camera_exid),
         {:ok, timestamp, _offset} <- DateTime.from_iso8601(timestamp) do
      SeaweedfsWorker.delete_snapshot(pid, timestamp)
    else
      _ ->
        :noop
    end
  end

  defp url_to_timestamp(path, file_name) do
    with %{
           "day" => day,
           "hour" => hour,
           "minute" => minutes,
           "month" => month,
           "seconds" => seconds,
           "year" => year,
           "camera_exid" => camera_exid
         } <- Regex.named_captures(@url_format, path <> "/" <> file_name) do
      {:ok, "#{year}-#{month}-#{day}T#{hour}:#{minutes}:#{seconds}Z", camera_exid}
    else
      _ ->
        {:timestamp_error, path <> "/" <> file_name}
    end
  end

  defp find_worker(camera_exid) do
    camera_exid
    |> String.to_atom()
    |> Process.whereis()
  end
end
