defmodule SeaweedfsSnapshotsDb do
  use Broadway

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {BroadwayKafka.Producer, [
          hosts: [localhost: 9092],
          group_id: "group_1",
          topics: ["snapshotsDB"],
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
