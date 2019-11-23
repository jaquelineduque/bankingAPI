defmodule BankWeb.Router do
  use BankWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticate do
    plug BankWeb.Plugs.Authenticate
  end

  scope "/api", BankWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
    post "/users/sign_in", UserController, :sign_in
  end

  scope "/restricted", BankWeb do
    pipe_through :authenticate
    get "/private", UserController, :valor_fixo
  end
end
