defmodule Bank.FinancialOperationType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "financial_operation_type" do
    field :code, :integer
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(financial_operation_type, attrs) do
    financial_operation_type
    |> cast(attrs, [:code, :description])
    |> validate_required([:code, :description])
    |> unique_constraint(:code)
  end
end
