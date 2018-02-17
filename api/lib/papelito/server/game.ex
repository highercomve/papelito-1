defmodule Papelito.Server.Game do

  use GenServer

  def start_link(game_id) do
    GenServer.start_link()
  end

  def init([game_id]) do
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



end
