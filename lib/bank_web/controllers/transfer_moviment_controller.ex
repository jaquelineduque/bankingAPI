defmodule BankWeb.TransferMovimentController do
  use BankWeb, :controller

  alias Bank.Financial
  alias Bank.Financial.TransferMoviment

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

  def create_transfer(conn, %{"transfer_moviment" => transfer_moviment_params}) do
    transfer_moviment = Bank.Helper.to_struct(%TransferMoviment{}, transfer_moviment_params)

    if Bank.Account.is_account_active(transfer_moviment.account_register_id_origin) do
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
      |> render("error.json", error: %{code: 1002, detail: "Conta inativa"})
    end
  end
end
