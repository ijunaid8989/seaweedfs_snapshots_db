defmodule SeaweedfsSnapshotsDb do
  use Broadway

  def start_link(_arg) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {BroadwayKafka.Producer, [
          hosts: [{"95.217.2.239", 9092}],
          group_id: "group_1",
          topics: ["snapshot_db"],
        ]},
        concurrency: 1
      ],
      processors: [
        default: [
          concurrency: 10
        ]
      ]
    )
  end

  def handle_message(_, message, _) do
    IO.inspect(message, label: "Got message")
  end
end
