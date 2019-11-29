defmodule Bank.Account.AccountRegister do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bank.User
  alias Bank.Account.Helper, as: Helper
  alias Bank.Account.AccountBalance, as: AccountBalance

  schema "account_register" do
    belongs_to :user, Bank.Auth.User
    field :account_number, :string
    field :active, :boolean, default: false
    field :agency_number, :string
    field :opening_date, :date
    has_one :account_balance, Bank.Account.AccountBalance

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(account_register, attrs) do
    account_register
    |> cast(attrs, [:user_id, :account_number, :active, :agency_number, :opening_date])
    |> validate_required([:user_id])
    # |> cast_assoc(:user_id)
    |> set_agency_number()
    |> set_account_number()

    # |> cast(attrs, [:agency_number, :accounnt_number, :active, :opening_date, :user_id])
    # |> validate_required([:agency_number, :accounnt_number, :active, :opening_date, :user_id])
  end

  def set_agency_number(changeset) do
    val_agency_number = get_field(changeset, :agency_number)

    if is_nil(val_agency_number) do
      agency_number = Helper.get_new_agency_number()
      put_change(changeset, :agency_number, agency_number)
    else
      changeset
    end
  end

  def set_account_number(changeset) do
    val_account_number = get_field(changeset, :account_number)

    if is_nil(val_account_number) do
      account_number = Helper.get_new_account_number()
      put_change(changeset, :account_number, account_number)
    else
      changeset
    end
  end

  def changeset_activate_account(account_register, attrs) do
  end
end
