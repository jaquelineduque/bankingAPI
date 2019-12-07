defmodule BankWeb.Router do
  use BankWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticate do
    plug BankWeb.Plugs.Authenticate
    plug :accepts, ["json"]
  end

  scope "/api", BankWeb do
    pipe_through :api
    post "/user", UserController, :create
    post "/user/login", UserController, :login
  end

  scope "/api", BankWeb do
    pipe_through :authenticate
    get "/user", UserController, :index
    get "/user/:id", UserController, :show
    post "/withdraw", FinancialMovimentController, :create_withdraw
    post "/deposit", FinancialMovimentController, :create_deposit
    post "/debit", FinancialMovimentController, :create_debit
    post "/transfer", TransferMovimentController, :create_transfer
    get "/balance", AccountBalanceController, :show
    get "/statement", FinancialMovimentController, :get_bank_statement
    resources "/account/client", ClientRegisterController, except: [:new, :edit]
    resources "/account", AccountRegisterController, except: [:new, :edit]
    post "/account/activate", AccountRegisterController, :activate
  end
end
