defmodule Papelito.GameManager do

  def new_game(subject) do
    game_name = Haikunator.build
    case Papelito.Supervisor.GameSupervisor.start_game({game_name, subject}) do
      {:ok, _} -> %{name: game_name}
      {:error, _} -> new_game(subject)
    end
  end

  def delete_game(game_name) do
    Papelito.Storage.delete_game(game_name)
    case Papelito.Server.Game.pid(game_name) do
      pid when is_pid(pid) ->
        Papelito.Supervisor.GameSupervisor.end_game(pid)
      nil ->
        :ok
    end
  end
end
