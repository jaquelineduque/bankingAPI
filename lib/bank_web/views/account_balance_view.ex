defmodule BankWeb.AccountBalanceView do
  use BankWeb, :view
  alias BankWeb.AccountBalanceView

  def render("index.json", %{account_balance: account_balance}) do
    %{accounts_balance: render_many(account_balance, AccountBalanceView, "account_balance.json")}
  end

  def render("show.json", %{account_balance: account_balance}) do
    %{account_balance: render_one(account_balance, AccountBalanceView, "account_balance.json")}
  end

  def render("account_balance.json", %{account_balance: account_balance}) do
    %{
      account_register_id: account_balance.account_register_id,
      balance_amount: account_balance.balance_amount
    }
  end

  def render("error.json", %{error: error}) do
    %{
      errors: error
    }
  end
end
