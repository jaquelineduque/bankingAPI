defmodule Bank.Repo.Migrations.CreateFinancialOperationType do
  use Ecto.Migration
  @primary_key {:id, :id, autogenerate: false}
  def change do
    create table(:financial_operation_type) do
      add :description, :text

      timestamps()
    end
  end
end
