defmodule BankWeb.FinancialMovimentController do
  use BankWeb, :controller

  alias Bank.Financial, as: Financial
  alias Bank.Financial.FinancialMoviment, as: FinancialMoviment
  alias Bank.Financial.TransferMoviment, as: TransferMoviment

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

  def validate_financial_moviment(financial_moviment) do
    cond do
      !Bank.Account.account_exists(financial_moviment.account_register_id) ->
        {false, 1051, "Conta não localizada"}

      !Bank.Account.is_account_active(financial_moviment.account_register_id) ->
        {false, 1052, "Conta inativa"}

      true ->
        {true, 0, ""}
    end
  end

  def create_withdraw(conn, %{"financial_moviment" => financial_moviment_params}) do
    financial_moviment = Bank.Helper.to_struct(%FinancialMoviment{}, financial_moviment_params)

    {valid_financial_moviment, error_code, error_message} =
      validate_financial_moviment(financial_moviment)

    if valid_financial_moviment do
      case Financial.create_withdraw(financial_moviment) do
        {:ok, %FinancialMoviment{} = financial_moviment} ->
          conn
          |> put_status(:created)
          |> render("show.json", financial_moviment: financial_moviment)

        {:error, %{code: 1001}} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render("error.json", error: %{code: 1001, detail: "Saldo insuficiente"})
      end
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render("error.json", error: %{code: error_code, detail: error_message})
    end
  end

  def create_deposit(conn, %{"financial_moviment" => financial_moviment_params}) do
    financial_moviment = Bank.Helper.to_struct(%FinancialMoviment{}, financial_moviment_params)

    {valid_financial_moviment, error_code, error_message} =
      validate_financial_moviment(financial_moviment)

    if valid_financial_moviment do
      case Financial.create_deposit(financial_moviment) do
        {:ok, %FinancialMoviment{} = financial_moviment} ->
          conn
          |> put_status(:created)
          |> render("show.json", financial_moviment: financial_moviment)
      end
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render("error.json", error: %{code: error_code, detail: error_message})
    end
  end

  def create_debit(conn, %{"financial_moviment" => financial_moviment_params}) do
    financial_moviment = Bank.Helper.to_struct(%FinancialMoviment{}, financial_moviment_params)

    if Bank.Account.is_account_active(financial_moviment.account_register_id) do
      case Financial.create_debit(financial_moviment) do
        {:ok, %FinancialMoviment{} = financial_moviment} ->
          conn
          |> put_status(:created)
          |> render("show.json", financial_moviment: financial_moviment)

        {:error, %{code: 1021}} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render("error.json", error: %{code: 1001, detail: "Saldo insuficiente"})
      end
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render("error.json", error: %{code: 1002, detail: "Conta inativa"})
    end
  end

  def get_bank_statement(conn, %{
        "account_register_id" => account_register_id,
        "starting_date" => starting_date,
        "ending_date" => ending_date
      }) do
    financial_moviment =
      Financial.get_financial_moviment(account_register_id, starting_date, ending_date)

    render(conn, "index.json", financial_moviment: financial_moviment)
  end
end
