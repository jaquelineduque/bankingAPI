defmodule Bank.Financial.TransferMoviment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bank.Financial.FinancialMoviment, as: FinancialMoviment

  schema "transfer_moviment" do
    belongs_to :financial_moviment, FinancialMoviment
    field :moviment_amount, :decimal
    field :account_register_id_origin, :id
    field :account_register_id_destiny, :id

    timestamps()
  end

  @doc false
  def changeset(transfer_moviment, attrs) do
    transfer_moviment
    |> cast(attrs, [:moviment_amount])
    |> validate_required([:moviment_amount])
  end
end
