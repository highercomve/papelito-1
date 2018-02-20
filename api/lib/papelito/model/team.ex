defmodule Papelito.Model.Team do

  alias __MODULE__

  defstruct players: [], score: 0, name: ""

  @type t :: %__MODULE__{
    players: [String.t()],
    name: String.t(),
    score: integer
  }

  @spec create(String.t) :: Team.t()
  def create(name) do
    %Team{ name: name }
  end

  @spec add_point(Team.t) :: Team.t()
  def add_point(%Team{} = team) do
    Map.put(team, :score, team.score + 1)
  end

  @spec add_player(Team.t(), String.t()) :: Team.t()
  def add_player(%Team{} = team , player_name) do
    players = [player_name | team.players]
    %Team{ team | players: players}
  end

end
