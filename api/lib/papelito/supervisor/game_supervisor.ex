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
    child_spec = {Papelito.Server.Game, {game_name_id, subject}}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def end_game(game_pid) do
    DynamicSupervisor.terminate_child(__MODULE__, game_pid)
  end

  def games do
    DynamicSupervisor.which_children(__MODULE__)
  end

  def count_games do
    DynamicSupervisor.count_children(__MODULE__)
  end

end
