defmodule Bank.Account.ClientRegister do
  use Ecto.Schema
  import Ecto.Changeset

  schema "client_register" do
    field :cpf, :string
    field :date_of_birth, :date
    field :name, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(client_register, attrs) do
    client_register
    |> cast(attrs, [:name, :cpf, :date_of_birth])
    |> validate_required([:name, :cpf, :date_of_birth])
    |> unique_constraint(:cpf)
  end
end
