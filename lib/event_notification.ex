defmodule EventNotification do
  require Logger
  @url_format ~r[/(?<camera_exid>.*)/snapshots/recordings/(?<year>\d{4})/(?<month>\d{1,2})/(?<day>\d{1,2})/(?<hour>\d{1,2})/(?<minute>\d{2})_(?<seconds>\d{2})_(?<milliseconds>\d{3})\.jpg]

  def upcoming_events(nil) do
    Logger.debug("NIL")
  end

  def upcoming_events(_message, %FilerPb.EventNotification{
        new_entry: %FilerPb.Entry{name: file_name},
        new_parent_path: path,
        old_entry: nil
      }) do
    %{
      "day" => day,
      "hour" => hour,
      "minute" => minutes,
      "month" => month,
      "seconds" => seconds,
      "year" => year,
      "camera_exid" => camera_exid
    } = Regex.named_captures(@url_format, path <> "/" <> file_name)
    datetime =
      "#{year}-#{month}-#{day}T#{hour}:#{minutes}:#{seconds}Z"
      |> DateTime.from_iso8601()
      |> elem(1)
    IO.inspect(datetime)
    IO.inspect(camera_exid)
  end

  def upcoming_events(%Broadway.Message{metadata: %{key: full_path}}, %FilerPb.EventNotification{
        new_entry: nil,
        new_parent_path: "",
        old_entry: %FilerPb.Entry{}
      }) do
    #Todo
  end
end


# %Broadway.Message{acknowledger: {BroadwayKafka.Acknowledger, {#PID<0.295.0>, {49, "snapshotsDB", 0}}, %{offset: 25}}, batch_key: {"snapshotsDB", 0}, batch_mode: :bulk, batcher: :default, data: <<10, 143, 1, 10, 13, 48, 48, 95, 52, 48, 95, 48, 48, 48, 46, 106, 112, 103, 26, 65, 10, 12, 50, 44, 51, 99, 97, 55, 56, 57, 51, 49, 97, 53, 24, 145, 166, 73, 32, 229, 178, 130, 191, 250, 148, ...>>, metadata: %{headers: [], key: "/andaz-rkugf/snapshots/recordings/2021/09/09/00/00/00_40_000.jpg", offset: 25, partition: 0, topic: "snapshotsDB", ts: -1}, status: :ok}, %FilerPb.EventNotification{__uf__: [], delete_chunks: true, is_from_other_cluster: false, new_entry: %FilerPb.Entry{__uf__: [], attributes: %FilerPb.FuseAttributes{__uf__: [], collection: "", crtime: 1629397787, disk_type: "", file_mode: 432, file_size: 1200913, gid: 1001, group_name: [], md5: <<17, 241, 118, 152, 80, 104, 137, 104, 109, 68, 58, 142, 91, 180, 31, 61>>, mime: "image/png", mtime: 1629397794, replication: "000", symlink_target: "", ttl_sec: 0, uid: 1001, user_name: ""}, chunks: [%FilerPb.FileChunk{__uf__: [], cipher_key: "", e_tag: "EfF2mFBoiWhtRDqOW7QfPQ==", fid: %FilerPb.FileId{__uf__: [], cookie: -1636179154, file_key: 61, volume_id: 1}, file_id: "", is_chunk_manifest: false, is_compressed: false, mtime: 1629397794633475200, offset: 0, size: 1200913, source_fid: nil, source_file_id: ""}], content: "", extended: %{}, hard_link_counter: 0, hard_link_id: "", is_directory: false, name: "00_40_000.jpg", remote_entry: nil}, new_parent_path: "/andaz-rkugf/snapshots/recordings/2021/09/09/00/00", old_entry: %FilerPb.Entry{__uf__: [], attributes: %FilerPb.FuseAttributes{__uf__: [], collection: "", crtime: 1629397787, disk_type: "", file_mode: 432, file_size: 1200913, gid: 1001, group_name: [], md5: <<17, 241, 118, 152, 80, 104, 137, 104, 109, 68, 58, 142, 91, 180, 31, 61>>, mime: "image/png", mtime: 1629397787, replication: "000", symlink_target: "", ttl_sec: 0, uid: 1001, user_name: ""}, chunks: [%FilerPb.FileChunk{__uf__: [], cipher_key: "", e_tag: "EfF2mFBoiWhtRDqOW7QfPQ==", fid: %FilerPb.FileId{__uf__: [], cookie: -1484181083, file_key: 60, volume_id: 2}, file_id: "2,3ca78931a5", is_chunk_manifest: false, is_compressed: false, mtime: 1629397787602884965, offset: 0, size: 1200913, source_fid: nil, source_file_id: ""}], content: "", extended: %{}, hard_link_counter: 0, hard_link_id: "", is_directory: false, name: "00_40_000.jpg", remote_entry: nil}, signatures: [881859918]}

# # %FilerPb.EventNotification{
# #   __uf__: [],
# #   delete_chunks: true,
# #   is_from_other_cluster: false,
# #   new_entry: %FilerPb.Entry{
# #     __uf__: [],
# #     attributes: %FilerPb.FuseAttributes{
#       __uf__: [],
#       collection: "",
#       crtime: 1629396971,
#       disk_type: "",
#       file_mode: 432,
#       file_size: 1200913,
#       gid: 1001,
#       group_name: [],
#       md5: <<17, 241, 118, 152, 80, 104, 137, 104, 109, 68, 58, 142, 91, 180,
#         31, 61>>,
#       mime: "image/png",
#       mtime: 1629397455,
#       replication: "000",
#       symlink_target: "",
#       ttl_sec: 0,
#       uid: 1001,
#       user_name: ""
#     },
#     chunks: [
#       %FilerPb.FileChunk{
#         __uf__: [],
#         cipher_key: "",
#         e_tag: "EfF2mFBoiWhtRDqOW7QfPQ==",
#         fid: %FilerPb.FileId{
#           __uf__: [],
#           cookie: 1105256333,
#           file_key: 55,
#           volume_id: 6
#         },
#         file_id: "",
#         is_chunk_manifest: false,
#         is_compressed: false,
#         mtime: 1629397455673265656,
#         offset: 0,
#         size: 1200913,
#         source_fid: nil,
#         source_file_id: ""
#       }
#     ],
#     content: "",
#     extended: %{},
#     hard_link_counter: 0,
#     hard_link_id: "",
#     is_directory: false,
#     name: "00_20_000.jpg",
#     remote_entry: nil
#   },
#   new_parent_path: "/andaz-rkugf/snapshots/recordings/2021/09/09/00/00",
#   old_entry: %FilerPb.Entry{
#     __uf__: [],
#     attributes: %FilerPb.FuseAttributes{
#       __uf__: [],
#       collection: "",
#       crtime: 1629396971,
#       disk_type: "",
#       file_mode: 432,
#       file_size: 1200913,
#       gid: 1001,
#       group_name: [],
#       md5: <<17, 241, 118, 152, 80, 104, 137, 104, 109, 68, 58, 142, 91, 180,
#         31, 61>>,
#       mime: "image/png",
#       mtime: 1629396987,
#       replication: "000",
#       symlink_target: "",
#       ttl_sec: 0,
#       uid: 1001,
#       user_name: ""
#     },
#     chunks: [
#       %FilerPb.FileChunk{
#         __uf__: [],
#         cipher_key: "",
#         e_tag: "EfF2mFBoiWhtRDqOW7QfPQ==",
#         fid: %FilerPb.FileId{
#           __uf__: [],
#           cookie: -1031014140,
#           file_key: 53,
#           volume_id: 4
#         },
#         file_id: "4,35c28bf904",
#         is_chunk_manifest: false,
#         is_compressed: false,
#         mtime: 1629396987444443903,
#         offset: 0,
#         size: 1200913,
#         source_fid: nil,
#         source_file_id: ""
#       }
#     ],
#     content: "",
#     extended: %{},
#     hard_link_counter: 0,
#     hard_link_id: "",
#     is_directory: false,
#     name: "00_20_000.jpg",
#     remote_entry: nil
#   },
#   signatures: [881859918]
# }
