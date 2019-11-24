defmodule Bank.Repo.Migrations.CreateAccountRegister do
  use Ecto.Migration

  def change do
    create table(:account_register) do
      add(:agency_number, :text)
      add(:account_number, :text)
      add(:active, :boolean, default: false, null: false)
      add(:opening_date, :date)
      add(:user_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:account_register, [:user_id]))
  end
end
