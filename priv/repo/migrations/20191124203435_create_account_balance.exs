defmodule Bank.Repo.Migrations.CreateAccountBalance do
  use Ecto.Migration

  def change do
    create table(:account_balance) do
      add :balance_amount, :decimal
      add :account_register_id, references(:account_register, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:account_balance, [:account_register_id])
  end
end
