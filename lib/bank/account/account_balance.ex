defmodule Bank.Account.AccountBalance do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bank.Account.AccountRegister, as: AccountRegister

  schema "account_balance" do
    belongs_to :account_register, Bank.Account.AccountRegister
    field :balance_amount, :decimal

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(account_balance, attrs) do
    account_balance
    |> cast(attrs, [:balance_amount, :account_register_id])
    |> validate_required([:balance_amount])
    |> unique_constraint(:account_register_id)
  end
end
