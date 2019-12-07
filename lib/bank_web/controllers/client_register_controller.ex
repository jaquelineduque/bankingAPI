defmodule BankWeb.ClientRegisterController do
  use BankWeb, :controller

  alias Bank.Account
  alias Bank.Account.ClientRegister

  action_fallback BankWeb.FallbackController

  def index(conn, _params) do
    client_register = Account.list_client_register()
    render(conn, "index.json", client_register: client_register)
  end

  def validate_client(client_register) do
    cond do
      !Bank.Helper.is_string_filled(client_register.user_id) ->
        {false, 4001, "Id do usuário não informado"}

      Account.user_has_client_register(client_register.user_id) ->
        {false, 4002, "Usuário já tem um cadastro"}

      !Bank.Helper.is_string_filled(client_register.cpf) ->
        {false, 4003, "CPF não informado"}

      Account.cpf_already_taken(client_register.cpf) ->
        {false, 4004, "CPF já cadastrado"}

      !Bank.Auth.user_exists(client_register.user_id) ->
        {false, 4005, "Id do usuário inválido"}

      !Bank.Helper.is_string_filled(client_register.name) ->
        {false, 4006, "Nome não informado"}

      !Bank.Helper.is_string_filled(client_register.date_of_birth) ->
        {false, 4007, "Data de nascimento não informada"}

      true ->
        {true, 0, ""}
    end
  end

  def create(conn, %{"client_register" => client_register_params}) do
    client_register_struct = Bank.Helper.to_struct(%ClientRegister{}, client_register_params)
    {valid_client, error_code, error_message} = validate_client(client_register_struct)

    if valid_client do
      with {:ok, %ClientRegister{} = client_register} <-
             Account.create_client_register(client_register_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.client_register_path(conn, :show, client_register))
        |> render("show.json", client_register: client_register)
      end
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render("error.json",
        error: %{code: error_code, detail: error_message}
      )
    end
  end

  def show(conn, %{"id" => id}) do
    client_register = Account.get_client_register!(id)
    render(conn, "show.json", client_register: client_register)
  end

  def update(conn, %{"id" => id, "client_register" => client_register_params}) do
    client_register = Account.get_client_register!(id)

    with {:ok, %ClientRegister{} = client_register} <-
           Account.update_client_register(client_register, client_register_params) do
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
