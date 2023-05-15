defmodule Obfuscate do
  @moduledoc false
  use Application

  require Logger

  def start(_args, _opts) do
    Logger.info("Booting up...")

    children = [{Bandit, plug: Obfuscate.Router, scheme: :http, port: 5488}, Obfuscate.InMemory]

    Supervisor.start_link(children, name: Obfuscate.Supervisor, strategy: :one_for_one)
  end
end
