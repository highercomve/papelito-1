defmodule Papelito.GameBuilder do

  def new_game(subject) do
    game_name = Haikunator.build
    case Papelito.Supervisor.GameSupervisor.start_game({game_name, subject}) do
      {:ok, _} -> %{name: game_name}
      {:error, _} -> new_game(subject)
    end
  end

end
