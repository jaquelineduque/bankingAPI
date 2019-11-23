defmodule Bank.Repo.Migrations.CreateClientRegister do
  use Ecto.Migration

  def change do
    create table(:client_register) do
      add :name, :text
      add :cpf, :text
      add :date_of_birth, :date
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:client_register, [:cpf])
    create index(:client_register, [:user_id])
  end
end
