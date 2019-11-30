defmodule Bank.FinancialOperationType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "financial_operation_type" do
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(financial_operation_type, attrs) do
    financial_operation_type
    |> cast(attrs, [:description])
    |> validate_required([:description])
  end
end
