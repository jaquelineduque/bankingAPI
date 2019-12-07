defmodule BankWeb.AccountRegisterController do
  use BankWeb, :controller

  alias Bank.Account
  alias Bank.Account.AccountRegister

  action_fallback BankWeb.FallbackController

  def index(conn, _params) do
    account_register = Account.list_account_register()
    render(conn, "index.json", account_register: account_register)
  end

  def validate_user(user_id) do
    cond do
      !(!!user_id) ->
        {false, 3001, "Usuário não informado"}

      Account.user_has_account_register(user_id) ->
        {false, 3002, "Usuário já tem uma conta"}

      !Bank.Auth.user_exists(user_id) ->
        {false, 3003, "Usuário não localizado"}

      true ->
        {true, 0, ""}
    end
  end

  def create(conn, %{"account_register" => account_register_params}) do
    account_reg = Bank.Helper.to_struct(%AccountRegister{}, account_register_params)

    {valid_user, error_code, error_message} = validate_user(account_reg.user_id)

    if valid_user do
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
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render("error.json", error: %{code: error_code, detail: error_message})
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
