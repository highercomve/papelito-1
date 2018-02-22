defmodule Papelito.Server.GameTest do
  use ExUnit.Case, async: true
  alias Papelito.Server.Game, as: GameServer
  alias Papelito.Model.Team

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
    game_state = %GameServer{}
    {:reply, round1, state_one} = Papelito.Server.Game.handle_call(:next_round, nil, game_state)
    assert round1 == 1

    {:reply, round2, state_two} = Papelito.Server.Game.handle_call(:next_round, nil, state_one)
    assert round2 == 2

    {:reply, round3, state_three} = Papelito.Server.Game.handle_call(:next_round, nil, state_two)
    assert round3 == 3

    # Round 4 == End game but still playing
    {:reply, round4, state_four} = Papelito.Server.Game.handle_call(:next_round, nil, state_three)
    assert round4 == 0

  end

  test "Add Paper" do
    #game_state = %GameServer{}
  end

  test "Add Player" do
    #game_state = %GameServer{}
  end
end
