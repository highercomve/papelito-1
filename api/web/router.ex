defmodule Papelito.Router do
  use Papelito.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Papelito do
    pipe_through :api
  end
end
