defmodule Papelito.GameControllerTest do
  use Papelito.ConnCase, async: true

  setup do
    {:ok, conn: put_req_header(build_conn(), "accept", "application/json")}
  end

  test "#create Create a game" do
    conn = build_conn()
    conn = post conn, game_path(conn, :create), %{subject: "Singers"}
    body = json_response(conn, 201)
    assert is_pid(Papelito.Server.Game.pid(body["name"]))
  end

  test "#delete Delete/eliminate a game" do
    name = Haikunator.build
    args = {name, "Singers"}
    {:ok, pid} = Papelito.Supervisor.GameSupervisor.start_game(args)

    conn = build_conn()
    conn = delete conn, game_path(conn, :delete, name)
    body = json_response(conn, 200)
    assert body["deleted"] == true
    assert Process.alive?(pid) == false
    assert :ets.lookup(:game_table, name) == []
  end

end
