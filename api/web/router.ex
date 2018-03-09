defmodule Papelito.Router do
  use Papelito.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", Papelito do
    pipe_through :api

    post "/games", GameController, :create
  end
end
