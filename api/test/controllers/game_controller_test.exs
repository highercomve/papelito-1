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

end
