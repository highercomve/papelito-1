defmodule Papelito.GameManager do

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
end
