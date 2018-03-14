defmodule Papelito.GameManager do
  require Logger

  alias Papelito.GamePlay
  alias Papelito.Model.{Game, GameLog}
  alias Papelito.Repo

  def new_game(subject) do
    game_name = Haikunator.build
    case Papelito.Supervisor.GameSupervisor.start_game({game_name, subject}) do
      {:ok, _} -> %{name: game_name}
      {:error, _} -> new_game(subject)
    end
  end

  def delete_game(game_name) do
    Logger.info "Deleting game #{game_name}"
    Papelito.Server.Game.terminate(game_name)
  end

  def save_game_log(game_name) do
    Papelito.Server.Game.summary(game_name)
    |> build_game_log(game_name)
    |> (&(GameLog.changeset(%GameLog{}, &1))).()
    |> Repo.insert()
  end

  def build_game_log(%GamePlay{} = game_play, game_name) do
    %{
      slug: game_name,
      winner: Enum.join(Game.winner(game_play.game), ","),
      teams: game_play.game.teams,
      words: game_play.game.papers
    }
  end

end
