defmodule Bank.Financial.FinancialMoviment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "financial_moviment" do
    field :moviment_amount, :decimal
    field :moviment_date, :naive_datetime_usec
    field :moviment_description, :string
    field :account_register_id, :id
    field :id_operation_type, :id
    field :id_moviment_type, :id

    timestamps()
  end

  @doc false
  def changeset(financial_moviment, attrs) do
    financial_moviment
    |> cast(attrs, [
      :moviment_amount,
      :moviment_date,
      :moviment_description,
      :account_register_id,
      :id_operation_type,
      :id_moviment_type
    ])
    |> validate_required([
      :moviment_amount,
      :account_register_id,
      :id_operation_type,
      :id_moviment_type
    ])
  end
end
