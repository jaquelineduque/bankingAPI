defmodule BankWeb.AccountBalanceController do
  use BankWeb, :controller

  alias Bank.Account
  alias Bank.Account.AccountBalance

  action_fallback BankWeb.FallbackController

  def index(conn, _params) do
    account_balance = Account.list_account_balance()
    render(conn, "index.json", account_balance: account_balance)
  end

  def create(conn, %{"account_balance" => account_balance_params}) do
    with {:ok, %AccountBalance{} = account_balance} <-
           Account.create_account_balance(account_balance_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.account_balance_path(conn, :show, account_balance))
      |> render("show.json", account_balance: account_balance)
    end
  end

  def show(conn, %{"id" => id}) do
    account_balance = Account.get_account_balance!(id)
    render(conn, "show.json", account_balance: account_balance)
  end

  def update(conn, %{"id" => id, "account_balance" => account_balance_params}) do
    account_balance = Account.get_account_balance!(id)

    with {:ok, %AccountBalance{} = account_balance} <-
           Account.update_account_balance(account_balance, account_balance_params) do
      render(conn, "show.json", account_balance: account_balance)
    end
  end

  def delete(conn, %{"id" => id}) do
    account_balance = Account.get_account_balance!(id)

    with {:ok, %AccountBalance{}} <- Account.delete_account_balance(account_balance) do
      send_resp(conn, :no_content, "")
    end
  end
end
