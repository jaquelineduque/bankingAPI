defmodule Bank.Account.ClientRegister do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bank.User

  schema "client_register" do
    belongs_to :user, Bank.User
    field :cpf, :string
    field :date_of_birth, :date
    field :name, :string
    # field :user_id, :id

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(client_register, attrs) do
    client_register
    |> cast(attrs, [:name, :cpf, :date_of_birth, :user_id])
    |> validate_required([:name, :cpf, :date_of_birth, :user_id])
    |> unique_constraint(:cpf)
  end
end
