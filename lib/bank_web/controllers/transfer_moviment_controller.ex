defmodule BankWeb.TransferMovimentController do
  use BankWeb, :controller

  alias Bank.Financial
  alias Bank.Financial.TransferMoviment
  alias Bank.Account

  action_fallback BankWeb.FallbackController

  def index(conn, _params) do
    transfer_moviment = Financial.list_transfer_moviment()
    render(conn, "index.json", transfer_moviment: transfer_moviment)
  end

  def create(conn, %{"transfer_moviment" => transfer_moviment_params}) do
    with {:ok, %TransferMoviment{} = transfer_moviment} <-
           Financial.create_transfer_moviment(transfer_moviment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.transfer_moviment_path(conn, :show, transfer_moviment)
      )
      |> render("show.json", transfer_moviment: transfer_moviment)
    end
  end

  def show(conn, %{"id" => id}) do
    transfer_moviment = Financial.get_transfer_moviment!(id)
    render(conn, "show.json", transfer_moviment: transfer_moviment)
  end

  def update(conn, %{"id" => id, "transfer_moviment" => transfer_moviment_params}) do
    transfer_moviment = Financial.get_transfer_moviment!(id)

    with {:ok, %TransferMoviment{} = transfer_moviment} <-
           Financial.update_transfer_moviment(transfer_moviment, transfer_moviment_params) do
      render(conn, "show.json", transfer_moviment: transfer_moviment)
    end
  end

  def delete(conn, %{"id" => id}) do
    transfer_moviment = Financial.get_transfer_moviment!(id)

    with {:ok, %TransferMoviment{}} <- Financial.delete_transfer_moviment(transfer_moviment) do
      send_resp(conn, :no_content, "")
    end
  end

  def validate_account_transfer(account_register_id_origin, account_register_id_destiny) do
    if account_register_id_origin == account_register_id_destiny do
      {false, 1010, "Conta de origem igual à de destino."}
    else
      account_origin_active = Bank.Account.is_account_active(account_register_id_origin)

      account_destiny_active = Bank.Account.is_account_active(account_register_id_destiny)

      cond do
        !account_origin_active && !account_destiny_active ->
          {false, 1010, "Contas de origem e destino inativas."}

        account_origin_active && !account_destiny_active ->
          {false, 1011, "Conta de destino inativa."}

        !account_origin_active && account_destiny_active ->
          {false, 1012, "Conta de origem inativa."}

        true ->
          {true, 0, ""}
      end
    end
  end

  def create_transfer(conn, %{"transfer_moviment" => transfer_moviment_params}) do
    transfer_moviment = Bank.Helper.to_struct(%TransferMoviment{}, transfer_moviment_params)

    # if Bank.Account.is_account_active(transfer_moviment.account_register_id_origin) do
    {active, error_code, error_message} =
      validate_account_transfer(
        transfer_moviment.account_register_id_origin,
        transfer_moviment.account_register_id_destiny
      )

    if active do
      case Financial.create_transfer(transfer_moviment) do
        {:ok, %TransferMoviment{} = transfer_moviment} ->
          conn
          |> put_status(:created)
          |> render("show.json", transfer_moviment: transfer_moviment)

        {:error, %{code: 1021}} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render("error.json", error: %{code: 1001, detail: "Saldo insuficiente"})
      end
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render("error.json",
        error: %{code: error_code, detail: error_message}
      )
    end
  end
end
