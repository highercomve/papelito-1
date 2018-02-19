defmodule Papelito.Server.Game do

  use GenServer

  alias Papelito.Model.Game
  alias Papelito.Model.Team

  def start_link(game_id) do
    GenServer.start_link()
  end

  def init([game_id]) do
    state = %{}
    {:ok, state}
  end


  def add_team(team_name) do
  end

  def add_player(team, player) do
  end

  def add_game_subject(subject) do
  end

  def add_data(data) do
  end

  def start_round() do
  end


  def handle_call({:add_team, team_name}, _from, state) do

    {:reply, :ok, %{}}
  end

  def handle_call() do
  end

  def handle_call() do
  end

  def handle_call() do
  end

  def handle_call() do
  end

  def handle_cast() do
  end

  def handle_cast() do
  end

  def handle_cast() do
  end

  def handle_cast() do
  end


  def handle_info() do
  end



end
