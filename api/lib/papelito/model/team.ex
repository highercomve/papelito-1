defmodule Papelito.Model.Team do

  alias __MODULE__

  defstruct players: [], score: 0, name: ""

  def create(name) do
    %Team{ name: name }
  end

  def add_point(%Team{} = team) do
    Map.put(team, score: team[:score] + 1)
  end

  def add_player(%Team{} = team ,player_name) do
    players = [player_name | team[:player]]
    %Team{ team | players: players}
  end
end
