defmodule Bank.Repo.Migrations.CreateTransferMoviment do
  use Ecto.Migration

  def change do
    create table(:transfer_moviment) do
      add :moviment_amount, :decimal
      add :account_register_id_origin, references(:account_register, on_delete: :nothing)
      add :account_register_id_destiny, references(:account_register, on_delete: :nothing)

      timestamps()
    end

    create index(:transfer_moviment, [:account_register_id_origin])
    create index(:transfer_moviment, [:account_register_id_destiny])
  end
end
