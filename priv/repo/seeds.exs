# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Bank.Repo.insert!(%Bank.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Bank.Repo
alias Bank.FinancialOperationType
alias Bank.FinancialMovimentType

# Populating - FinancialOperationType
Repo.insert!(%FinancialOperationType{
  id: 1,
  description: "Saque"
})

Repo.insert!(%FinancialOperationType{
  id: 2,
  description: "Depósito"
})

Repo.insert!(%FinancialOperationType{
  id: 3,
  description: "Transferência"
})

Repo.insert!(%FinancialOperationType{
  id: 4,
  description: "Débito automático"
})

# Populating - FinancialOperationType
Repo.insert!(%FinancialMovimentType{
  id: 1,
  description: "Crédito"
})

Repo.insert!(%FinancialMovimentType{
  id: 2,
  description: "Débito"
})
