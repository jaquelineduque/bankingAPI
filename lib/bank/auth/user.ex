defmodule Bank.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :is_active, :boolean, default: false
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :auth_tokens, Bank.AuthToken
    has_many :account_register, Bank.Account.AccountRegister
    # has_many :client_register, Bank.ClientRegister

    # Add support for microseconds at the language level
    # for this specific schema
    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :is_active, :password])
    |> validate_required([:email, :is_active, :password])
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end
end
