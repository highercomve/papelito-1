defmodule Papelito.Server.GameTest do
  use ExUnit.Case, async: true
  alias Papelito.Server.Game, as: GameServer
  alias Papelito.Model.Team


  test "Init Server" do
    {:ok, state} = Papelito.Server.Game.init(["Rock Bands"])
    assert state.game.subject == "Rock Bands"
    assert state.round == 0
    assert state.started == false
    assert is_nil(state.current_paper)
  end

  test "Start game" do
    {:ok, state} = Papelito.Server.Game.init(["Rock Bands"])
    {:reply, :ok, new_state} = Papelito.Server.Game.handle_call(:start, nil, state)
    assert new_state.round == 1
    assert new_state.started == true
  end

  test "Add Team" do
    game_state = %GameServer{}
    team_one = %Team{ name: "team_one", players: [], score: 0}

    {:reply, :ok, new_state} = Papelito.Server.Game.handle_call({:add_team, "team_one"}, nil, game_state)
    assert new_state.game.teams["team_one"] == team_one

    team_two = %Team{ name: "team_two", players: [], score: 0}
    {:reply, :ok, new_new_state} = Papelito.Server.Game.handle_call({:add_team, "team_two"}, nil, new_state)
    assert new_new_state.game.teams["team_one"] == team_one
    assert new_new_state.game.teams["team_two"] == team_two
  end

  test "Next Round" do
    previous_papers = ["Paper 1", "Paper 2", "Paper 3"]
    game_state = %GameServer{previous_papers: previous_papers}
    {:reply, round1, state_one} = Papelito.Server.Game.handle_call(:next_round, nil, game_state)
    assert round1 == 1
    assert state_one.round == round1
    assert state_one.previous_papers == []

    {:reply, round2, state_two} = Papelito.Server.Game.handle_call(:next_round, nil, %GameServer{state_one | previous_papers: previous_papers})
    assert round2 == 2
    assert state_two.round == round2
    assert state_two.previous_papers == []

    {:reply, round3, state_three} = Papelito.Server.Game.handle_call(:next_round, nil, %GameServer{state_two | previous_papers: previous_papers})
    assert round3 == 3
    assert state_three.round == round3
    assert state_three.previous_papers == []

    # Round 4 == End game but still playing
    {:reply, round4, state_four} = Papelito.Server.Game.handle_call(:next_round, nil, %GameServer{state_three | previous_papers: previous_papers})
    assert round4 == 0
    assert state_four.round == round4
    assert state_three.previous_papers == []
  end

  test "Paper[Add]" do
    game_state = %GameServer{}
    paper_one = "JK Simmons"

    {:reply, paper_one, state_one} = Papelito.Server.Game.handle_call({:add_paper, paper_one}, nil, game_state)
    assert state_one.game.papers == [paper_one]

    paper_two = "Harry Potter"
    {:reply, paper_two, state_two} = Papelito.Server.Game.handle_call({:add_paper, paper_two}, nil, state_one)
    assert state_two.game.papers == [paper_two, paper_one]
  end

  test "Paper[Fetch]" do
    game_state = %GameServer{}
    papers = ["JK Simmons","Harry Potter"]
    {:reply, papers, state_one} = Papelito.Server.Game.handle_call({:add_paper, papers}, nil, game_state)

    {:reply, paper, state_two} = Papelito.Server.Game.handle_call(:fetch_paper, nil, state_one)
    assert is_binary(paper)
    assert Enum.member?(papers, paper)
    assert state_two.current_paper == paper
    assert length(state_two.previous_papers) == 0

    {:reply, paper_a, state_three} = Papelito.Server.Game.handle_call(:fetch_paper, nil, state_two)
    assert is_binary(paper_a)
    assert Enum.member?(papers, paper_a)
    assert state_three.current_paper == paper_a
    assert length(state_three.previous_papers) == 1

    {:reply, nil, state_four} = Papelito.Server.Game.handle_call(:fetch_paper, nil, state_three)
    assert state_four.current_paper == nil
    assert length(state_four.previous_papers) == 2
  end

  test "Add Player" do
    game_state = %GameServer{}
    [player_one, player_two, player_one_b, player_two_b] = ["Marceline", "BMO", "Finn", "Jake"]
    {:reply, :ok, new_state} = Papelito.Server.Game.handle_call({:add_team, ["team_one", "team_two"]}, nil, game_state)

    {:reply, team_one, new_new_state} = Papelito.Server.Game.handle_call({:add_player, "team_one", player_one}, nil, new_state)
    assert team_one.players == [player_one]

    {:reply, team_one, new_x3_state} = Papelito.Server.Game.handle_call({:add_player, "team_one", player_two}, nil, new_new_state)
    assert team_one.players == [player_two, player_one]

    {:reply, team_two, new_x4_state} = Papelito.Server.Game.handle_call({:add_player, "team_two", player_one_b}, nil, new_x3_state)
    assert team_two.players == [player_one_b]

    {:reply, team_two, _new_x5_state} = Papelito.Server.Game.handle_call({:add_player, "team_two", player_two_b}, nil, new_x4_state)
    assert team_two.players == [player_two_b, player_one_b]
  end

end
