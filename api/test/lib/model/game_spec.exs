defmodule Papelito.Model.GameTest do
  use ExUnit.Case

  alias Papelito.Model.Game
  alias Papelito.Model.Team

  test "Create game" do
    game = %Game{subject: "Phrases", papers: [], teams: []}

    assert Game.create("Phrases") == game
  end

  test "Add team" do
    game = %Game{subject: "Phrases", papers: [], teams: []}
    team_one_name = "team_one"
    team_one = %Team{name: team_one_name, players: [], score: 0}

    game = Game.add_team(game, team_one_name)

    assert Enum.member?(game.teams, team_one)


    team_two = %Team{name: "t_two", players: [], score: 0}
    team_three = %Team{name: "t_3", players: [], score: 0}
    game = Game.add_team(game, ["t_two", "t_3"])

    assert length(game.teams) == 3
    assert Enum.member?(game.teams, team_two)
    assert Enum.member?(game.teams, team_three)

  end

  test "Add point to a specific team" do
    team_one = %Team{name: "t_one", players: [], score: 0}
    team_two = %Team{name: "t_two", players: [], score: 0}

    game_a = %Game{subject: "Phrases", papers: [], teams: [team_one, team_two]}
    updated_game_a = Game.add_point_to_team(game_a, "t_one")
    team_with_one_point = %Team{name: "t_one", players: [], score: 1}
    assert Enum.member?(updated_game_a.teams, team_with_one_point)

    game_b = %Game{subject: "Phrases", papers: [], teams: [team_with_one_point, team_two]}
    updated_game_b = Game.add_point_to_team(game_b, "t_one")
    team_with_two_point = %Team{name: "t_one", players: [], score: 2}
    assert Enum.member?(updated_game_b.teams, team_with_two_point)

    game_c = %Game{subject: "Phrases", papers: [], teams: [team_one, team_two]}
    updated_game_c= Game.add_point_to_team(game_c, "t_two")
    team_two_with_one_point = %Team{name: "t_two", players: [], score: 1}
    assert Enum.member?(updated_game_c.teams, team_two_with_one_point)

  end

  test "Winner" do

    team_one_a = %Team{name: "t_one", players: [], score: 10}
    team_two_a = %Team{name: "t_two", players: [], score: 15}
    game_a = %Game{subject: "Phrases", papers: [], teams: [team_one_a, team_two_a]}

    assert Game.winner(game_a) == [team_two_a]

    # Tie

    team_one_b = %Team{name: "t_one", players: [], score: 10}
    team_two_b = %Team{name: "t_two", players: [], score: 15}
    team_three_b = %Team{name: "t_three", players: [], score: 15}
    game_b = %Game{subject: "Phrases", papers: [], teams: [team_one_b, team_two_b, team_three_b]}

    assert  Game.winner(game_b) == [team_two_b, team_three_b]
  end

  test "Add papers" do
    one = "JK Simmons"
    two = "Fracisco de Miranda"
    three = "Elon Musk"

    team_one = %Team{name: "t_one", players: [], score: 0}
    team_two = %Team{name: "t_two", players: [], score: 0}
    game = %Game{subject: "Characters", teams: [team_one, team_two], papers: [] }

    game = Game.add_paper(game, one)
    assert game.papers == [one]

    game = Game.add_paper(game, [two, three])
    assert game.papers == [one, two, three]
  end

end
