defmodule BankWeb.ClientRegisterView do
  use BankWeb, :view
  alias BankWeb.ClientRegisterView

  def render("index.json", %{client_register: client_register}) do
    %{data: render_many(client_register, ClientRegisterView, "client_register.json")}
  end

  def render("show.json", %{client_register: client_register}) do
    %{data: render_one(client_register, ClientRegisterView, "client_register.json")}
  end

  def render("client_register.json", %{client_register: client_register}) do
    %{id: client_register.id,
      name: client_register.name,
      cpf: client_register.cpf,
      date_of_birth: client_register.date_of_birth}
  end
end
