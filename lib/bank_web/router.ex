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
    resources "/client", ClientRegisterController, except: [:new, :edit]
    resources "/account", AccountRegisterController, except: [:new, :edit]
    post "/account/activate", AccountRegisterController, :activate
    post "/financial/withdraw", FinancialMovimentController, :create_withdraw
    post "/financial/deposit", FinancialMovimentController, :create_deposit
    post "/financial/debit", FinancialMovimentController, :create_debit
    post "/financial/transfer", TransferMovimentController, :create_transfer
    get "/financial/balance", AccountBalanceController, :show
    get "/financial/statement", FinancialMovimentController, :get_bank_statement
  end
end
