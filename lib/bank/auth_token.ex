defmodule Bank.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset

  # alias Bank.AuthToken
  # alias Bank.User

  schema "auth_tokens" do
    belongs_to :user, Bank.Auth.User
    field :revoked, :boolean, default: false
    field :revoked_at, :utc_datetime
    field :token, :string
    # field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(auth_token, attrs) do
    auth_token
    |> cast(attrs, [:token])
    |> validate_required([:token])
    |> unique_constraint(:token)
  end
end
