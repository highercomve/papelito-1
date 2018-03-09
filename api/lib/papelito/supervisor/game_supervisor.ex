defmodule Papelito.Supervisor.GameSupervisor do
  use DynamicSupervisor
  require Logger

  def start_link(_args) do
    Logger.info "Starting #{__MODULE__} supervisor"
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_game({game_name_id, subject}) do
    child_spec = %{
      id: Papelito.Server.Game,
      start: {Papelito.Server.Game, :start_link, [game_name_id, subject]},
      restart: :transient
    }
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def end_game(game_name_id) do
    :ets.delete(:game_table, game_name_id)
    game_pid = Papelito.Server.Game.pid(game_name_id)
    DynamicSupervisor.terminate_child(__MODULE__, game_pid)
  end

  def games do
    DynamicSupervisor.which_children(__MODULE__)
  end

  def count_games do
    DynamicSupervisor.count_children(__MODULE__)
  end

end
