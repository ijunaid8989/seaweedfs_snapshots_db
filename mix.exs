defmodule SeaweedfsSnapshotsDb.MixProject do
  use Mix.Project

  def project do
    [
      app: :seaweedfs_snapshots_db,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SeaweedfsSnapshotsDb.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:broadway_kafka, "~> 0.1.1"}
    ]
  end
end