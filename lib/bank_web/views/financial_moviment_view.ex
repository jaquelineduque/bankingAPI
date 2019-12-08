defmodule BankWeb.FinancialMovimentView do
  use BankWeb, :view
  alias BankWeb.FinancialMovimentView

  def render("index.json", %{financial_moviment: financial_moviment}) do
    %{
      financial_moviments:
        render_many(financial_moviment, FinancialMovimentView, "financial_moviment.json")
    }
  end

  def render("show.json", %{financial_moviment: financial_moviment}) do
    %{
      financial_moviment:
        render_one(financial_moviment, FinancialMovimentView, "financial_moviment.json")
    }
  end

  def render("financial_moviment.json", %{financial_moviment: financial_moviment}) do
    %{
      id: financial_moviment.id,
      moviment_amount: financial_moviment.moviment_amount,
      moviment_date: financial_moviment.moviment_date,
      moviment_description: financial_moviment.moviment_description
    }
  end

  def render("error.json", %{error: error}) do
    %{
      errors: error
    }
  end
end
