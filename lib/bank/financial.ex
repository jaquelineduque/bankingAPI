defmodule Bank.Financial do
  @moduledoc """
  The Financial context.
  """

  import Ecto.Query, warn: false
  alias Bank.Repo

  alias Bank.Account.AccountBalance, as: AccountBalance

  alias Bank.Financial.FinancialMoviment, as: FinancialMoviment

  @doc """
  Returns the list of financial_moviment.

  ## Examples

      iex> list_financial_moviment()
      [%FinancialMoviment{}, ...]

  """
  def list_financial_moviment do
    Repo.all(FinancialMoviment)
  end

  @doc """
  Gets a single financial_moviment.

  Raises `Ecto.NoResultsError` if the Financial moviment does not exist.

  ## Examples

      iex> get_financial_moviment!(123)
      %FinancialMoviment{}

      iex> get_financial_moviment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_financial_moviment!(id), do: Repo.get!(FinancialMoviment, id)

  @doc """
  Creates a financial_moviment.

  ## Examples

      iex> create_financial_moviment(%{field: value})
      {:ok, %FinancialMoviment{}}

      iex> create_financial_moviment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_financial_moviment(attrs \\ %{}) do
    %FinancialMoviment{}
    |> FinancialMoviment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a financial_moviment.

  ## Examples

      iex> update_financial_moviment(financial_moviment, %{field: new_value})
      {:ok, %FinancialMoviment{}}

      iex> update_financial_moviment(financial_moviment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_financial_moviment(%FinancialMoviment{} = financial_moviment, attrs) do
    financial_moviment
    |> FinancialMoviment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a FinancialMoviment.

  ## Examples

      iex> delete_financial_moviment(financial_moviment)
      {:ok, %FinancialMoviment{}}

      iex> delete_financial_moviment(financial_moviment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_financial_moviment(%FinancialMoviment{} = financial_moviment) do
    Repo.delete(financial_moviment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking financial_moviment changes.

  ## Examples

      iex> change_financial_moviment(financial_moviment)
      %Ecto.Changeset{source: %FinancialMoviment{}}

  """
  def change_financial_moviment(%FinancialMoviment{} = financial_moviment) do
    FinancialMoviment.changeset(financial_moviment, %{})
  end

  def is_account_active(id) do
    account_register = get_financial_moviment!(id)
    account_register.active
  end

  def create_withdraw(%FinancialMoviment{} = financial_moviment) do
    actual_datetime = DateTime.utc_now()
    account_register_id = financial_moviment.account_register_id
    balance_register = Bank.Account.get_account_balance(account_register_id)

    if Decimal.lt?(balance_register.balance_amount, financial_moviment.moviment_amount) do
      # Não prosseguir e gerar mensagem de saldo insuficiente
      {:error, %{code: 1001, detail: "Saldo insuficiente"}}
    else
      new_balance =
        Decimal.sub(balance_register.balance_amount, financial_moviment.moviment_amount)

      Ecto.Multi.new()
      |> Ecto.Multi.update(
        :balance_register,
        AccountBalance.changeset(balance_register, %{
          account_register_id: financial_moviment.account_register_id,
          balance_amount: new_balance
        })
      )
      |> Ecto.Multi.insert(
        :financial_moviment,
        FinancialMoviment.changeset(financial_moviment, %{
          moviment_amount: financial_moviment.moviment_amount,
          moviment_date: actual_datetime,
          moviment_description: financial_moviment.moviment_description,
          account_register_id: financial_moviment.account_register_id,
          id_operation_type: 1,
          id_moviment_type: 2
        })
      )
      |> Repo.transaction()
      |> case do
        {:ok, %{financial_moviment: financial_moviment}} ->
          {:ok, financial_moviment}

        {:error, _, reason, _} ->
          {:error, reason}
      end
    end
  end

  def create_deposit(%FinancialMoviment{} = financial_moviment) do
  end
end
