defmodule Papelito.GameController do
  use Papelito.Web, :controller

  def create(conn, params) do
    payload = Papelito.GameBuilder.new_game(params["subject"])
    conn
    |> put_status(201)
    |> json(payload)
  end
end
