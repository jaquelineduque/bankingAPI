defmodule Bank.Account.AccountRegister do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bank.User
  alias Bank.Account.Helper, as: Helper

  schema "account_register" do
    belongs_to :user, User
    field :account_number, :string
    field :active, :boolean, default: false
    field :agency_number, :string
    field :opening_date, :date
    # field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(account_register, attrs) do
    account_register
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
    |> set_agency_number()
    |> set_account_number()

    # |> cast(attrs, [:agency_number, :accounnt_number, :active, :opening_date, :user_id])
    # |> validate_required([:agency_number, :accounnt_number, :active, :opening_date, :user_id])
  end

  defp set_agency_number(changeset) do
    agency_number = Helper.get_new_agency_number()
    put_change(changeset, :agency_number, agency_number)
  end

  defp set_account_number(changeset) do
    account_number = Helper.get_new_account_number()
    put_change(changeset, :account_number, account_number)
  end
end
