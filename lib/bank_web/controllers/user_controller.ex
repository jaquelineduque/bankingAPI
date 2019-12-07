defmodule BankWeb.UserController do
  use BankWeb, :controller

  alias Bank.Auth
  alias Bank.Auth.User

  action_fallback BankWeb.FallbackController

  def index(conn, _params) do
    users = Auth.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    user_struct = Bank.Helper.to_struct(%User{}, user_params)

    if Auth.is_email_already_taken(user_struct.email) do
      conn
      |> put_status(:unprocessable_entity)
      |> render("error.json", error: %{code: 3001, detail: "E-mail já cadastrado"})
    else
      with {:ok, %User{} = user} <- Auth.create_user(user_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, user))
        |> render("show.json", user: user)
      end
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

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Bank.Auth.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> put_view(BankWeb.UserView)
        |> render("sign_in.json", user: user)

      {:error, message} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(BankWeb.ErrorView)
        |> render("error.json", error: %{code: 3000, message: message})
    end
  end

  def valor_fixo(conn, _params) do
    send_resp(conn, :ok, "")
  end
end
