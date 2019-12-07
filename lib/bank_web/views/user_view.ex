defmodule BankWeb.UserView do
  use BankWeb, :view
  alias BankWeb.UserView

  def render("index.json", %{users: users}) do
    %{users: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{user: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email, is_active: user.is_active}
  end

  def render("sign_in.json", %{user: user}) do
    %{
      users: %{
        user: %{
          id: user.id,
          token: user.token
        }
      }
    }
  end

  def render("error.json", %{error: error}) do
    %{
      errors: error
    }
  end
end
