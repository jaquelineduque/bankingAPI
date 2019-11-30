defmodule Bank.FinancialMovimentType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "financial_moviment_type" do
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(financial_moviment_type, attrs) do
    financial_moviment_type
    |> cast(attrs, [:description])
    |> validate_required([:description])
  end
end
