defmodule Bank.Account.AccountBalance do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bank.Account.AccountRegister, as: AccountRegister

  schema "account_balance" do
    belongs_to :account_register, AccountRegister
    field :balance_amount, :decimal
    # field :account_register_id, :id

    timestamps()
  end

  @doc false
  def changeset(account_balance, attrs) do
    account_balance
    |> cast(attrs, [:balance_amount])
    |> validate_required([:balance_amount])
    |> unique_constraint(:account_register_id)
  end
end
