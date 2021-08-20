defmodule EventNotification do
  require Logger

  @url_format ~r[/(?<camera_exid>.*)/snapshots/recordings/(?<year>\d{4})/(?<month>\d{1,2})/(?<day>\d{1,2})/(?<hour>\d{1,2})/(?<minute>\d{2})_(?<seconds>\d{2})_(?<milliseconds>\d{3})\.jpg]

  def upcoming_events(nil) do
    Logger.debug("NIL")
  end

  def upcoming_events(_message, %FilerPb.EventNotification{
        new_entry: %FilerPb.Entry{name: file_name},
        new_parent_path: path
      }) do
    with %{
           "day" => day,
           "hour" => hour,
           "minute" => minutes,
           "month" => month,
           "seconds" => seconds,
           "year" => year,
           "camera_exid" => camera_exid
         } <- Regex.named_captures(@url_format, path <> "/" <> file_name),
         true <- camera_exid in ["andaz-rkugf", "everc-shawt"] do
      "#{year}-#{month}-#{day}T#{hour}:#{minutes}:#{seconds}Z"
      |> DateTime.from_iso8601()
      |> Snapshots.add_snapshot(camera_exid)

      Logger.debug("NIL")
    else
      _ ->
        Logger.debug("NIL")
    end
  end

  def upcoming_events(%Broadway.Message{metadata: %{key: full_path}}, %FilerPb.EventNotification{
        new_entry: nil,
        new_parent_path: "",
        old_entry: %FilerPb.Entry{}
      }) do
    # Todo
  end
end
