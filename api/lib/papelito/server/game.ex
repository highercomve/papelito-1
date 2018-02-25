defmodule Papelito.Server.Game do

  use GenServer
  require Logger

  @max_rounds 3

  alias Papelito.Model.Game, as: GameData
  alias Papelito.Model.Team

  defstruct game: %GameData{},
            current_paper: nil,
            previous_papers: [],
            round: 0,
            current_team: nil,
            teams_order: []

  def start_link([], {game_name_id, subject}) do
    start_link({game_name_id, subject})
  end

  def start_link({game_name_id, subject}) do
    name = via_tuple(game_name_id)
    GenServer.start_link(__MODULE__, subject, name: name)
  end

  defp via_tuple(game_name_id) do
    {:via, Registry, {:game_registry, game_name_id}}
  end

  def init(subject) do
    state = %__MODULE__{
      game: GameData.create(subject)
    }
    {:ok, state}
  end

  ##------------------##
  ##    Client API    ##
  ##------------------##

  def start(game_name_id) do
    GenServer.call(via_tuple(game_name_id), :start)
  end

  def next_team(game_name_id) do
    GenServer.call(via_tuple(game_name_id), :next_team)
  end

  def add_team(game_name_id, team_name) do
    GenServer.cast(via_tuple(game_name_id), {:add_team, team_name})
  end

  def add_player(game_name_id, team_name, player) do
    GenServer.cast(via_tuple(game_name_id), {:add_player, team_name, player})
  end

  def add_paper(game_name_id, paper) do
    GenServer.call(via_tuple(game_name_id), {:add_paper, paper})
  end

  def fetch_paper(game_name_id) do
    GenServer.call(via_tuple(game_name_id), :fetch_paper)
  end

  def start_round(game_name_id) do
    GenServer.call(via_tuple(game_name_id), :next_round)
  end

  def next_round(game_name_id) do
    GenServer.call(via_tuple(game_name_id), :next_round)
  end

  def add_point(game_name_id, team_name) do
    GenServer.cast(via_tuple(game_name_id), {:add_point, team_name})
  end

  ##------------------##
  ##    Server API    ##
  ##------------------##

  def handle_call(:start, _from, state) do
    teams_order = Map.keys(state.game.teams) |> Enum.shuffle
    current_team = Enum.at(teams_order, 0)
    new_state = %__MODULE__{ state | round: 1, teams_order: teams_order, current_team: current_team }
    {:reply, :ok, new_state}
  end

  def handle_call(:next_team, _from, state) do
    team_index = Enum.find_index(state.teams_order, fn(team) -> state.current_team == team end)
    team_index = if is_nil(team_index), do: length(state.teams_order) - 1, else: team_index
    current_team = Enum.at(state.teams_order, rem(team_index + 1, length(state.teams_order)))
    new_state = %__MODULE__{state | current_team: current_team}
    {:reply, current_team, new_state}
  end

  def handle_call(:next_round, _from, state) do
    next_round = rem(state.round + 1, @max_rounds + 1)
    new_state = %__MODULE__{ state | round: next_round, previous_papers: []}
    {:reply, next_round, new_state}
  end

  def handle_call({:add_paper, paper}, _from, state) do
    game = GameData.add_paper(state.game, paper)
    {:reply, paper, %__MODULE__{ state | game: game}}
  end


  def handle_call(:fetch_paper, _from, state) do
    previous_papers = Enum.filter([state.current_paper | state.previous_papers], fn(paper) -> is_nil(paper) == false end)
    unselected_papers = MapSet.difference(MapSet.new(state.game.papers), MapSet.new(previous_papers))
    current_paper = case Enum.any?(unselected_papers) do
      true -> Enum.random(unselected_papers)
      _ -> nil
    end
    new_state = %__MODULE__{state | current_paper: current_paper, previous_papers: previous_papers}
    {:reply, new_state.current_paper, new_state}
  end

  def handle_cast({:add_team, team_name}, state) do
    game = GameData.add_team(state.game, team_name)
    new_state = %__MODULE__{ state | game: game }
    {:noreply,  new_state}
  end

  def handle_cast({:add_player, team_name, player}, state) do
    team = Team.add_player(state.game.teams[team_name], player)
    teams = Map.put(state.game.teams, team_name, team)
    game = %GameData{ state.game | teams: teams }
    {:noreply, %__MODULE__{ state | game: game }}
  end

  def handle_cast({:add_point, team_name}, state) do
    team = Team.add_point(state.game.teams[team_name])
    teams = Map.put(state.game.teams, team_name, team)
    game = %GameData{ state.game | teams: teams }
    {:noreply, %__MODULE__{ state | game: game }}
  end

  def handle_info(message, state) do
    Logger.error "GameServer did not recognize this message #{inspect message}"
    {:noreply, state}
  end
end
