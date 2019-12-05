defmodule BankWeb.AccountRegisterController do
  use BankWeb, :controller

  alias Bank.Account
  alias Bank.Account.AccountRegister

  action_fallback BankWeb.FallbackController

  def index(conn, _params) do
    account_register = Account.list_account_register()
    render(conn, "index.json", account_register: account_register)
  end

  def create(conn, %{"account_register" => account_register_params}) do
    account_reg = Bank.Helper.to_struct(%AccountRegister{}, account_register_params)

    if Account.user_has_account_register(account_reg.user_id) do
      conn
      |> put_status(:unprocessable_entity)
      |> render("error.json",
        error: %{code: 3001, detail: "Usuário já tem uma conta."}
      )
    else
      with {:ok, %AccountRegister{} = account_register} <-
             Account.create_account_register(account_register_params) do
        conn
        |> put_status(:created)
        |> put_resp_header(
          "location",
          Routes.account_register_path(conn, :show, account_register)
        )
        |> render("show.json", account_register: account_register)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    account_register = Account.get_account_register!(id)
    render(conn, "show.json", account_register: account_register)
  end

  def update(conn, %{"id" => id, "account_register" => account_register_params}) do
    account_register = Account.get_account_register!(id)

    with {:ok, %AccountRegister{} = account_register} <-
           Account.update_account_register(account_register, account_register_params) do
      render(conn, "show.json", account_register: account_register)
    end
  end

  def delete(conn, %{"id" => id}) do
    account_register = Account.get_account_register!(id)

    with {:ok, %AccountRegister{}} <- Account.delete_account_register(account_register) do
      send_resp(conn, :no_content, "")
    end
  end

  def activate(conn, %{"account_id" => account_id}) do
    account_register = Account.get_account_register!(account_id)

    with {:ok, %AccountRegister{} = account_register} <-
           Account.activate_account_register(account_register) do
      render(conn, "show.json", account_register: account_register)
    end
  end
end
