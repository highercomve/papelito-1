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
    %Game{
      subject: Papelito.Utils.Sanitizer.clean(subject)
    }
  end

  @spec add_team(Game.t(), String.t()) :: Game.t()
  def add_team(%Game{} = game, team_name) when is_binary(team_name) do
    new_team = Team.create(team_name)
    %Game{ game | teams: [new_team | game.teams] }
  end

  @spec add_team(Game.t(), Enumerable.t()) :: Game.t()
  def add_team(%Game{} = game, teams_name) when is_list(teams_name) do
    teams = Enum.map(teams_name, &Team.create/1) |> Enum.into(game.teams)
    %Game{ game | teams: teams }
  end


  @spec add_point_to_team(Game.t(), String.t()) :: Game.t()
  def add_point_to_team(%Game{} = game, team_name) do
    team = Enum.find(game.teams, fn(team) -> team.name == team_name end)
    teams = List.delete(game.teams, team)
            |> List.insert_at(-1, Team.add_point(team))
    %Game{ game | teams: teams }
  end

  @spec winner(Game.t()) :: Team.t()
  def winner(%Game{} = game) do
    max_score = Enum.map(game.teams, fn(team) -> team.score end) |> Enum.max
    winners = Enum.filter(game.teams, fn(team) -> team.score == max_score end)
  end

  @spec add_paper(Game.t(), String.t()) :: Game.t()
  def add_paper(%Game{} = game, paper) when is_binary(paper) do
    %Game{ game | papers: [paper | game.papers] }
  end

  @spec add_paper(Game.t(), Enumerable.t()) :: Game.t()
  def add_paper(%Game{} = game, papers) when is_list(papers) do
    %Game{ game | papers: Enum.into(papers, game.papers) }
  end
end
