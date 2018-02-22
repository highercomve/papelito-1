defmodule Papelito.Server.Game do

  use GenServer

  @max_rounds 3

  alias Papelito.Model.Game, as: GameData
  alias Papelito.Model.Team

  defstruct game: %GameData{},
            current_paper: "",
            previous_papers: [],
            round: 0,
            started: false,
            current_team: ""


  def start_link([slug, subject]) do
    name = via_tuple(slug)
    GenServer.start_link(__MODULE__, [slug, subject], name: name)
  end

  defp via_tuple(slug) do
    {:via, Registry, {:game_registry, slug}}
  end

  def init([slug, subject]) do
    state = %__MODULE__{
      game: GameData.create(subject)
    }
    {:ok, state}
  end

  ##------------------##
  ##    Client API    ##
  ##------------------##

  def add_team(slug, team_name) do
    GenServer.call(via_tuple(slug), {:add_team, team_name})
  end

  def add_player(slug, team_name, player) do
    GenServer.call(via_tuple(slug), {:add_player, team_name, player})
  end

  def add_paper(slug, paper) do
    GenServer.call(via_tuple(slug), {:add_paper, paper})
  end

  def start_round(slug) do
    GenServer.call(via_tuple(slug), :next_round)
  end

  def next_round(slug) do
    GenServer.call(via_tuple(slug), :next_round)
  end

  ##------------------##
  ##    Server API    ##
  ##------------------##

  def handle_call({:add_team, team_name}, _from, state) do
    game = GameData.add_team(state.game, team_name)
    new_state = %__MODULE__{ state | game: game }
    {:reply, :ok, new_state}
  end

  def handle_call(:next_round, _from, state) do
    next_round = rem(state.round + 1, @max_rounds + 1)
    new_state = %__MODULE__{ state | round: next_round}
    {:reply, next_round, new_state}
  end

  def handle_call({:add_paper, paper}, _from, state) do
    game = GameData.add_paper(state.game, paper)
    {:reply, paper, %__MODULE__{ state | game: game}}
  end

  def handle_call({:add_player, team_name, player}, _from, state) do
    team = Team.add_player(state.game.teams[team_name], player)
    teams = Map.put(state.game.teams, team_name, team)
    game = %GameData{ state.game | teams: teams }
    {:reply, team, %__MODULE__{ state | game: game }}
  end

  def handle_cast() do
  end

  def handle_info() do
  end
end
