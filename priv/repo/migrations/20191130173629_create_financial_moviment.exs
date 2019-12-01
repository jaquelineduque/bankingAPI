defmodule Bank.Repo.Migrations.CreateFinancialMoviment do
  use Ecto.Migration

  def change do
    create table(:financial_moviment) do
      add :moviment_amount, :decimal
      add :moviment_date, :utc_datetime_usec
      add :moviment_description, :text
      add :account_register_id, references(:account_register, on_delete: :nothing)
      add :id_operation_type, references(:financial_operation_type, on_delete: :nothing)
      add :id_moviment_type, references(:financial_moviment_type, on_delete: :nothing)

      timestamps()
    end

    create index(:financial_moviment, [:account_register_id])
    create index(:financial_moviment, [:id_operation_type])
    create index(:financial_moviment, [:id_moviment_type])
  end
end
