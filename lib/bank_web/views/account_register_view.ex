defmodule BankWeb.AccountRegisterView do
  use BankWeb, :view
  alias BankWeb.AccountRegisterView

  def render("index.json", %{account_register: account_register}) do
    %{accounts: render_many(account_register, AccountRegisterView, "account_register.json")}
  end

  def render("show.json", %{account_register: account_register}) do
    %{account: render_one(account_register, AccountRegisterView, "account_register.json")}
  end

  def render("account_register.json", %{account_register: account_register}) do
    %{
      id: account_register.id,
      agency_number: account_register.agency_number,
      account_number: account_register.account_number,
      active: account_register.active,
      opening_date: account_register.opening_date
    }
  end

  def render("error.json", %{error: error}) do
    %{
      errors: error
    }
  end
end
