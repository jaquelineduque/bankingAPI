defmodule Bank.Account.AccountRegister do
  use Ecto.Schema
  import Ecto.Changeset

  schema "account_register" do
    belongs_to :user, User
    field :accounnt_number, :string
    field :active, :boolean, default: false
    field :agency_number, :string
    field :opening_date, :date
    # field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(account_register, attrs) do
    account_register
    |> cast(attrs, [:agency_number, :accounnt_number, :active, :opening_date])
    |> validate_required([:agency_number, :accounnt_number, :active, :opening_date])
  end
end
