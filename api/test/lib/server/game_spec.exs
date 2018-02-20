defmodule Papelito.Server.GameTest do
  use ExUnit.Case, async: true

  setup do
    game_server = start_supervised!(Papelito.Server.Game)
    %{game_server: game_server}
  end

end
