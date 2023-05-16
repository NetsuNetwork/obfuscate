defmodule Obfuscate.InMemory do
  @moduledoc """
  In-Memory database, entries are flushed every 12 hours
  """

  use GenServer

  import Logger

  @impl true
  def init(state) do
    flush_time = Application.get_env(:obfuscate, :flush_time, "3600000") |> String.to_integer()
    schedule(flush_time)
    {:ok, state}
  end

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def handle_cast({:set, id, url}, state) do
    if Map.has_key?(state, id) do
      {:noreply, state}
    end

    expr = Timex.now() |> Timex.shift(hours: +12) |> Timex.to_unix
    new_state = state |> Map.put(id, {url, expr})

    IO.puts inspect expr

    {:noreply, new_state}
  end

  @impl true
  def handle_call({:get, id}, _from, state) do
    res = state |> Map.get(id)
    {:reply, res, state}
  end

  @impl true
  def handle_info({:flush, flush_time}, state) do
    schedule(flush_time)

    keys = state |> Map.keys()

    if !keys do
      {:noreply, state}
    end

    current_unix = Timex.now() |> Timex.to_unix

    keys = keys |> Enum.filter(fn key ->
      {_url, expr} = state |> Map.get(key)
      current_unix > expr
    end)

    dropped = length(keys)
    new_state = state |> Map.drop(keys)

    Logger.debug("DB: #{dropped} were dropped")

    # Old code :3
    # for key <- keys do
    #   {_url, expr} = state |> Map.get(key)
    #   IO.puts inspect expr
    #   IO.puts inspect Timex.today() |> Timex.to_unix()
    #   if Date.utc_today() |> Timex.to_unix > expr do
    #     new_state = state |> Map.delete(key)
    #     state = state |> Map.delete(key)
    #   end
    # end

    Logger.debug("DB: flushed")

    {:noreply, new_state}
  end

  @spec schedule(integer()) :: any()
  defp schedule(flush_time), do: Process.send_after(self(), {:flush, flush_time}, flush_time)

  @spec set(String.t(), String.t()) :: any()
  def set(id, url) do
    GenServer.cast(__MODULE__, {:set, id, url})
  end

  @spec get(String.t()) :: String.t() | nil
  def get(id) do
    res = GenServer.call(__MODULE__, {:get, id})

    case res do
      nil -> nil
      {url, _expr} -> url
    end
  end
end
