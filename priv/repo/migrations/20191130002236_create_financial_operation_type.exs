defmodule Bank.Repo.Migrations.CreateFinancialOperationType do
  use Ecto.Migration

  def change do
    create table(:financial_operation_type) do
      add :code, :integer
      add :description, :text

      timestamps()
    end

    create unique_index(:financial_operation_type, [:code])
  end
end
