defmodule SeaweedfsSnapshotsDb do
  use Broadway

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayKafka.Producer,
           [
              hosts: [localhost: 9092],
              group_id: "group_1",
              topics: ["snapshotsDB"],
              offset_commit_on_ack: false,
              offset_commit_interval_seconds: 30
           ]},
        concurrency: 10
      ],
      processors: [
        default: [
          concurrency: 50
        ]
      ]
    )
  end

  def handle_message(_, message, _) do
    {:ok, data} = FilerPb.EventNotification.decode(message.data)
    EventNotification.upcoming_events(message, data)
    message
  end
end
