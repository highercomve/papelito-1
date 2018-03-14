defmodule Papelito.GameController do
  use Papelito.Web, :controller

  def create(conn, params) do
    payload = Papelito.GameManager.new_game(params["subject"])
    conn
    |> put_status(201)
    |> json(payload)
  end

  def delete(conn, %{"id" => game_name}) do
    :ok = Papelito.GameManager.delete_game(game_name)
    conn
    |> put_status(200)
    |> json(%{deleted: true})
  end
end
