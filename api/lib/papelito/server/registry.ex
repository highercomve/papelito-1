defmodule Papelito.Server.Registry do

  use GenSserver

  ##---------##
  ##         ##
  ##---------##

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: :game_registry)
  end

  ##---------##
  ##         ##
  ##---------##

  def whereis_name(game_name) do
    GenServer.call(:game_registry, {:whereis_name, game_name})
  end

  def register_name(game_name, pid) do
    GenServer.call(:game_registry, {:register_name, game_name, pid})
  end

  def unregister_name(game_name) do
    GenServer.cast(:game_registry, {:unregister_name, game_name})
  end

  def send(game_name, message) do
    case whereis_name(game_name) do
      :undefined ->
        {:badarg, {game_name, message}}

      pid - >
        # Send message
        # investigate to send a messages using a GenServer instead Kernel.send
        pid
    end
  end

  ##--------##
  ## Server ##
  ##--------##

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:whereis_name, game_name}, _from, state) do
    {:reply, Map.get(state, game_name, :undefined), state}
  end

  def handle_call({:register_name, game_name, pid}, _from, state) do
    case Map.get(state, game_name) do
      nil ->
        {:reply, :yes, Map.put(state, game_name, pid)}
      _ ->
        {:reply, :no, state}
    end
  end

  def handle_cast({:unregister_name, game_names}, state) do
    {:noreply, Map.delete(state, game_name)}
  end


end
