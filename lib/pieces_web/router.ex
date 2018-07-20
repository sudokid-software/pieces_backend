defmodule PiecesWeb.Router do
  use PiecesWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PiecesWeb do
    pipe_through :api
  end
end
