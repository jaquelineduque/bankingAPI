defmodule Bank.Repo.Migrations.CreateFinancialMovimentType do
  use Ecto.Migration

  @primary_key {:id, :id, autogenerate: false}
  def change do
    create table(:financial_moviment_type) do
      add :description, :text

      timestamps()
    end
  end
end
