defmodule BankWeb.ClientRegisterController do
  use BankWeb, :controller

  alias Bank.Account
  alias Bank.Account.ClientRegister

  action_fallback BankWeb.FallbackController

  def index(conn, _params) do
    client_register = Account.list_client_register()
    render(conn, "index.json", client_register: client_register)
  end

  def create(conn, %{"client_register" => client_register_params}) do
    with {:ok, %ClientRegister{} = client_register} <- Account.create_client_register(client_register_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.client_register_path(conn, :show, client_register))
      |> render("show.json", client_register: client_register)
    end
  end

  def show(conn, %{"id" => id}) do
    client_register = Account.get_client_register!(id)
    render(conn, "show.json", client_register: client_register)
  end

  def update(conn, %{"id" => id, "client_register" => client_register_params}) do
    client_register = Account.get_client_register!(id)

    with {:ok, %ClientRegister{} = client_register} <- Account.update_client_register(client_register, client_register_params) do
      render(conn, "show.json", client_register: client_register)
    end
  end

  def delete(conn, %{"id" => id}) do
    client_register = Account.get_client_register!(id)

    with {:ok, %ClientRegister{}} <- Account.delete_client_register(client_register) do
      send_resp(conn, :no_content, "")
    end
  end
end
