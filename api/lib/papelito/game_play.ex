defmodule Papelito.GamePlay do

  @max_rounds 3

  alias __MODULE__
  alias Papelito.Model.Game, as: GameData
  alias Papelito.Model.Team

  defstruct game: %GameData{},
            current_paper: nil,
            previous_papers: [],
            round: 0,
            current_team: nil,
            teams_order: []

  @type t :: %__MODULE__{
    game: GameData.t(),
    current_paper: String.t(),
    previous_papers: [String.t()],
    round: integer,
    current_team: String.t(),
    teams_order: [String.t]
  }
  @spec new(GamePlay.t()) :: GamePlay.t()
  def new(subject) do
    %__MODULE__{
      game: GameData.create(subject)
    }
  end

  @spec start(GamePlay.t()) :: GamePlay.t()
  def start(%GamePlay{} = game_play) do
    teams_order = Map.keys(game_play.game.teams) |> Enum.shuffle
    current_team = Enum.at(teams_order, 0)
    %__MODULE__{ game_play | round: 1, teams_order: teams_order, current_team: current_team }
  end

  @spec next_team(GamePlay.t()) :: {String.t(), GamePlay.t()}
  def next_team(%GamePlay{} = game_play) do
    team_index = Enum.find_index(game_play.teams_order, fn(team) -> game_play.current_team == team end)
    team_index = if is_nil(team_index), do: length(game_play.teams_order) - 1, else: team_index
    current_team = Enum.at(game_play.teams_order, rem(team_index + 1, length(game_play.teams_order)))
    {current_team, %__MODULE__{ game_play | current_team: current_team }}
  end

  @spec next_team(GamePlay.t()) :: {integer, GamePlay.t()}
  def next_round(%GamePlay{} = game_play) do
    next_round = rem(game_play.round + 1, @max_rounds + 1)
    {next_round, %__MODULE__{ game_play | round: next_round, previous_papers: []}}
  end

  @spec add_paper(GamePlay.t(), String.t()) :: GamePlay.t()
  def add_paper(%GamePlay{} = game_play, paper) do
    game = GameData.add_paper(game_play.game, paper)
    %__MODULE__{ game_play | game: game }
  end

  @spec fetch_paper(GamePlay.t()) :: {String.t(), GamePlay.t()}
  def fetch_paper(%GamePlay{} = game_play) do
    previous_papers = Enum.filter([game_play.current_paper | game_play.previous_papers], fn(paper) -> is_nil(paper) == false end)
    unselected_papers = MapSet.difference(MapSet.new(game_play.game.papers), MapSet.new(previous_papers))
    current_paper = case Enum.any?(unselected_papers) do
      true -> Enum.random(unselected_papers)
      _ -> nil
    end
    %__MODULE__{ game_play | current_paper: current_paper, previous_papers: previous_papers}
  end

  @spec add_team(GamePlay.t(), String.t()) :: GamePlay.t()
  def add_team(%GamePlay{} = game_play, team) do
    game = GameData.add_team(game_play.game, team)
    %__MODULE__{ game_play | game: game }
  end


  @spec add_player(GamePlay.t(), String.t(), String.t()) :: GamePlay.t()
  def add_player(%GamePlay{} = game_play, team_name, player) do
    team = Team.add_player(game_play.game.teams[team_name], player)
    teams = Map.put(game_play.game.teams, team_name, team)
    game = %GameData{ game_play.game | teams: teams }
    %__MODULE__{ game_play | game: game }
  end

  @spec add_point(GamePlay.t(), String.t()) :: GamePlay.t()
  def add_point(%GamePlay{} = game_play, team_name) do
    team = Team.add_point(game_play.game.teams[team_name])
    teams = Map.put(game_play.game.teams, team_name, team)
    game = %GameData{ game_play.game | teams: teams }
    %__MODULE__{ game_play | game: game }
  end

end
