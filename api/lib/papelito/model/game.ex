defmodule Papelito.Model.Game do

  alias __MODULE__

  alias Papelito.Model.Team

  defstruct subject: "", teams: [], papers: []

  @type t :: %__MODULE__{
    subject: String.t(),
    teams: [Team.t()],
    papers: [String.t()]
  }

  @spec create(String.t()) :: Game.t()
  def create(subject) do
    %Game{ subject: subject }
  end

  @spec add_team(Game.t(), String.t()) :: Game.t()
  def add_team(%Game{} = game, team_name) do
    new_team = Team.create(team_name)
    %Game{ game | teams: [new_team | game.teams]}
  end

  @spec add_point_to_team(Game.t(), String.t()) :: Game.t()
  def add_point_to_team(%Game{} = game, team_name) do
    team = Enum.find(game.teams, fn(team) -> team.name == team_name end)
    teams = List.delete(game.teams, team)
            |> List.insert_at(-1, Team.add_point(team))
    %Game{ game | teams: teams}
  end


end
