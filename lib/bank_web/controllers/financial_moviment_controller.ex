defmodule BankWeb.FinancialMovimentController do
  use BankWeb, :controller

  alias Bank.Financial, as: Financial
  alias Bank.Financial.FinancialMoviment, as: FinancialMoviment

  action_fallback BankWeb.FallbackController

  def index(conn, _params) do
    financial_moviment = Financial.list_financial_moviment()
    render(conn, "index.json", financial_moviment: financial_moviment)
  end

  def create(conn, %{"financial_moviment" => financial_moviment_params}) do
    with {:ok, %FinancialMoviment{} = financial_moviment} <-
           Financial.create_financial_moviment(financial_moviment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.financial_moviment_path(conn, :show, financial_moviment)
      )
      |> render("show.json", financial_moviment: financial_moviment)
    end
  end

  def show(conn, %{"id" => id}) do
    financial_moviment = Financial.get_financial_moviment!(id)
    render(conn, "show.json", financial_moviment: financial_moviment)
  end

  def update(conn, %{"id" => id, "financial_moviment" => financial_moviment_params}) do
    financial_moviment = Financial.get_financial_moviment!(id)

    with {:ok, %FinancialMoviment{} = financial_moviment} <-
           Financial.update_financial_moviment(financial_moviment, financial_moviment_params) do
      render(conn, "show.json", financial_moviment: financial_moviment)
    end
  end

  def delete(conn, %{"id" => id}) do
    financial_moviment = Financial.get_financial_moviment!(id)

    with {:ok, %FinancialMoviment{}} <- Financial.delete_financial_moviment(financial_moviment) do
      send_resp(conn, :no_content, "")
    end
  end

  def create_withdraw(conn, %{"financial_moviment" => financial_moviment_params}) do
    financial_moviment = to_struct(%FinancialMoviment{}, financial_moviment_params)

    with {:ok, %FinancialMoviment{} = financial_moviment} <-
           Financial.create_withdraw(financial_moviment) do
      conn
      |> put_status(:created)
      |> render("show.json", financial_moviment: financial_moviment)
    end
  end

  def to_struct(kind, attrs) do
    struct = struct(kind)

    Enum.reduce(Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(attrs, Atom.to_string(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end)
  end
end
