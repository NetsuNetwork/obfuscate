defmodule Obfuscate.Database.InMemory do
  @moduledoc """
  In-Memory database
  """

  use GenServer

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: :in_memdb)
  end

  @impl true
  def handle_cast({:set, id, url}, state) do
    if Map.has_key?(state, id) do
      {:noreply, state}
    end

    new_state = state |> Map.merge(%{id, url})

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

  def handle_info({:flush}, state) do
    {:noreply, %{} }
  end

  @spec set(String.t(), String.t()) :: any()
  def set(id, url) do
    GenServer.cast(__MODULE__, {:set, id, url})
  end

  @spec get(String.t()) :: any()
  def get(id) do
    GenServer.call(__MODULE__, {:get, id})
  end
end
