defmodule Obfuscate.InMemory do
  @moduledoc """
  In-Memory database, entries are flushed every 12 hours
  """

  use GenServer

  import Logger

  @impl true
  def init(state) do
    flush_time = Application.get_env(:obfuscate, :flush_time, "3600000")
    schedule(String.to_integer(flush_time))
    {:ok, state}
  end

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: :in_memdb)
  end

  @impl true
  def handle_cast({:set, id, url}, state) do
    if Map.has_key?(state, id) do
      {:noreply, state}
    end

    new_state = state |> Map.merge(%{id: id, url: url})

    {:noreply, new_state}
  end

  @impl true
  def handle_call({:get, id}, _from, state) do
    if Map.has_key?(state, id) do
      url = state |>Map.get(id)

      {:reply, url, state}
    end

    {:reply, "URL does not exist...", state}
  end

  @impl true
  def handle_info({:flush, flush_time}, _state) do
    schedule(flush_time)

    Logger.info("I-MDB: flushed")
    {:noreply, %{} }
  end

  @spec schedule(integer()) :: any()
  defp schedule(flush_time), do: Process.send_after(self(), {:flush, flush_time}, flush_time)

  @spec set(String.t(), String.t()) :: any()
  def set(id, url) do
    GenServer.cast(__MODULE__, {:set, id, url})
  end

  @spec get(String.t()) :: any()
  def get(id) do
    GenServer.call(__MODULE__, {:get, id})
  end
end
