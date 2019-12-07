defmodule BankWeb.UserController do
  use BankWeb, :controller

  alias Bank.Auth
  alias Bank.Auth.User

  action_fallback BankWeb.FallbackController

  def index(conn, _params) do
    users = Auth.list_users()
    render(conn, "index.json", users: users)
  end

  def is_string_filled(value) do
    !!value && value != ""
  end

  def is_user_email_and_password_filled(email, password) do
    cond do
      !is_string_filled(email) && !is_string_filled(password) ->
        {false, 3010, "E-mail e senha não informados"}

      !is_string_filled(email) ->
        {false, 3011, "E-mail não informado"}

      !is_string_filled(password) ->
        {false, 3012, "Senha não informada"}

      true ->
        {true, 0, ""}
    end
  end

  def validate_user(user) do
    {email_password_filled, error_code, error_message} =
      is_user_email_and_password_filled(user.email, user.password)

    cond do
      !email_password_filled ->
        {email_password_filled, error_code, error_message}

      Auth.is_email_already_taken(user.email) ->
        {false, 3013, "E-mail já cadastrado"}

      true ->
        {true, 0, ""}
    end
  end

  def create(conn, %{"user" => user_params}) do
    user_struct = Bank.Helper.to_struct(%User{}, user_params)

    {user_valid, error_code, error_message} = validate_user(user_struct)

    if user_valid do
      with {:ok, %User{} = user} <- Auth.create_user(user_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, user))
        |> render("show.json", user: user)
      end
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render("error.json", error: %{code: error_code, detail: error_message})
    end
  end

  def show(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Auth.get_user!(id)

    with {:ok, %User{} = user} <- Auth.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Auth.get_user!(id)

    with {:ok, %User{}} <- Auth.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def login(conn, %{"user" => user_params}) do
    user_struct = Bank.Helper.to_struct(%User{}, user_params)

    {email_password_filled, error_code, error_message} =
      is_user_email_and_password_filled(user_struct.email, user_struct.password)

    if email_password_filled do
      case Bank.Auth.authenticate_user(user_struct.email, user_struct.password) do
        {:ok, user} ->
          conn
          |> put_status(:ok)
          |> put_view(BankWeb.UserView)
          |> render("login.json", user: user)

        {:error, message} ->
          conn
          |> put_status(:unauthorized)
          |> put_view(BankWeb.ErrorView)
          |> render("error.json", error: %{code: 3000, message: message})
      end
    else
      conn
      |> put_status(:unprocessable_entity)
      |> put_view(BankWeb.ErrorView)
      |> render("error.json", error: %{code: error_code, message: error_message})
    end
  end

  def valor_fixo(conn, _params) do
    send_resp(conn, :ok, "")
  end
end
