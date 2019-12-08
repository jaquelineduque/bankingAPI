defmodule Bank.Financial do
  @moduledoc """
  The Financial context.
  """

  import Ecto.Query, warn: false
  alias Bank.Repo

  alias Bank.Account.AccountBalance, as: AccountBalance

  alias Bank.Financial.FinancialMoviment, as: FinancialMoviment

  @moviment_credit 1
  @moviment_debit 2
  @operation_withdraw 1
  @operation_deposit 2
  @operation_transfer 3
  @operation_debit 4

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

  def create_simple_financial_moviment(
        %FinancialMoviment{} = financial_moviment,
        new_balance,
        moviment_type,
        operation_type
      ) do
    actual_datetime = DateTime.utc_now()
    account_register_id = financial_moviment.account_register_id
    balance_register = Bank.Account.get_account_balance(account_register_id)

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
        id_moviment_type: moviment_type,
        id_operation_type: operation_type
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

  def create_withdraw(%FinancialMoviment{} = financial_moviment) do
    account_register_id = financial_moviment.account_register_id
    balance_register = Bank.Account.get_account_balance(account_register_id)

    if Decimal.lt?(
         Decimal.cast(balance_register.balance_amount),
         Decimal.cast(financial_moviment.moviment_amount)
       ) do
      # Não prosseguir e gerar mensagem de saldo insuficiente
      {:error, %{code: 1001, detail: "Saldo insuficiente"}}
    else
      new_balance =
        Decimal.sub(
          Decimal.cast(balance_register.balance_amount),
          Decimal.cast(financial_moviment.moviment_amount)
        )

      create_simple_financial_moviment(
        financial_moviment,
        new_balance,
        @moviment_debit,
        @operation_withdraw
      )
    end
  end

  def create_deposit(%FinancialMoviment{} = financial_moviment) do
    account_register_id = financial_moviment.account_register_id

    balance_register = Bank.Account.get_account_balance(account_register_id)

    new_balance =
      Decimal.add(
        Decimal.cast(balance_register.balance_amount),
        Decimal.cast(financial_moviment.moviment_amount)
      )

    create_simple_financial_moviment(
      financial_moviment,
      new_balance,
      @moviment_credit,
      @operation_deposit
    )
  end

  def create_debit(%FinancialMoviment{} = financial_moviment) do
    account_register_id = financial_moviment.account_register_id
    balance_register = Bank.Account.get_account_balance(account_register_id)

    if Decimal.lt?(
         Decimal.cast(balance_register.balance_amount),
         Decimal.cast(financial_moviment.moviment_amount)
       ) do
      # Não prosseguir e gerar mensagem de saldo insuficiente
      {:error, %{code: 1001, detail: "Saldo insuficiente"}}
    else
      new_balance =
        Decimal.sub(
          Decimal.cast(balance_register.balance_amount),
          Decimal.cast(financial_moviment.moviment_amount)
        )

      create_simple_financial_moviment(
        financial_moviment,
        new_balance,
        @moviment_debit,
        @operation_debit
      )
    end
  end

  @doc """
  Returns the list of financial_moviment by account with a range date.

  """
  def get_financial_moviment(account_register_id, starting_date, ending_date) do
    {:ok, converted_starting_date} =
      NaiveDateTime.new(Date.from_iso8601!(starting_date), ~T[00:00:00])

    {:ok, converted_ending_date} =
      NaiveDateTime.new(Date.from_iso8601!(ending_date), ~T[23:59:59])

    query =
      from f in FinancialMoviment,
        where:
          f.account_register_id == ^account_register_id and
            f.moviment_date >= ^converted_starting_date and
            f.moviment_date <= ^converted_ending_date,
        select: f

    Repo.all(query)
  end

  alias Bank.Financial.TransferMoviment

  @doc """
  Returns the list of transfer_moviment.

  ## Examples

      iex> list_transfer_moviment()
      [%TransferMoviment{}, ...]

  """
  def list_transfer_moviment do
    Repo.all(TransferMoviment)
  end

  @doc """
  Gets a single transfer_moviment.

  Raises `Ecto.NoResultsError` if the Transfer moviment does not exist.

  ## Examples

      iex> get_transfer_moviment!(123)
      %TransferMoviment{}

      iex> get_transfer_moviment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transfer_moviment!(id), do: Repo.get!(TransferMoviment, id)

  @doc """
  Creates a transfer_moviment.

  ## Examples

      iex> create_transfer_moviment(%{field: value})
      {:ok, %TransferMoviment{}}

      iex> create_transfer_moviment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transfer_moviment(attrs \\ %{}) do
    %TransferMoviment{}
    |> TransferMoviment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transfer_moviment.

  ## Examples

      iex> update_transfer_moviment(transfer_moviment, %{field: new_value})
      {:ok, %TransferMoviment{}}

      iex> update_transfer_moviment(transfer_moviment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transfer_moviment(%TransferMoviment{} = transfer_moviment, attrs) do
    transfer_moviment
    |> TransferMoviment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TransferMoviment.

  ## Examples

      iex> delete_transfer_moviment(transfer_moviment)
      {:ok, %TransferMoviment{}}

      iex> delete_transfer_moviment(transfer_moviment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transfer_moviment(%TransferMoviment{} = transfer_moviment) do
    Repo.delete(transfer_moviment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transfer_moviment changes.

  ## Examples

      iex> change_transfer_moviment(transfer_moviment)
      %Ecto.Changeset{source: %TransferMoviment{}}

  """
  def change_transfer_moviment(%TransferMoviment{} = transfer_moviment) do
    TransferMoviment.changeset(transfer_moviment, %{})
  end

  def create_transfer(%TransferMoviment{} = transfer_moviment) do
    account_register_id_origin = transfer_moviment.account_register_id_origin

    balance_register_origin =
      Bank.Account.get_account_balance(transfer_moviment.account_register_id_origin)

    balance_register_destiny =
      Bank.Account.get_account_balance(transfer_moviment.account_register_id_destiny)

    if Decimal.lt?(balance_register_origin.balance_amount, transfer_moviment.moviment_amount) do
      # Não prosseguir e gerar mensagem de saldo insuficiente
      {:error, %{code: 1001, detail: "Saldo insuficiente"}}
    else
      new_balance_origin =
        Decimal.sub(balance_register_origin.balance_amount, transfer_moviment.moviment_amount)

      new_balance_destiny =
        Decimal.add(balance_register_destiny.balance_amount, transfer_moviment.moviment_amount)

      actual_datetime = DateTime.utc_now()
      financial_moviment = %FinancialMoviment{}

      Ecto.Multi.new()
      |> Ecto.Multi.update(
        :balance_register_origin,
        AccountBalance.changeset(balance_register_origin, %{
          account_register_id: transfer_moviment.account_register_id_origin,
          balance_amount: new_balance_origin
        })
      )
      |> Ecto.Multi.update(
        :balance_register_destiny,
        AccountBalance.changeset(balance_register_destiny, %{
          account_register_id: transfer_moviment.account_register_id_destiny,
          balance_amount: new_balance_destiny
        })
      )
      |> Ecto.Multi.insert(
        :financial_moviment_origin,
        FinancialMoviment.changeset(financial_moviment, %{
          moviment_amount: transfer_moviment.moviment_amount,
          moviment_date: actual_datetime,
          moviment_description: "Transferência enviada.",
          account_register_id: transfer_moviment.account_register_id_origin,
          id_moviment_type: @moviment_debit,
          id_operation_type: @operation_transfer
        })
      )
      |> Ecto.Multi.insert(
        :financial_moviment_destiny,
        FinancialMoviment.changeset(financial_moviment, %{
          moviment_amount: transfer_moviment.moviment_amount,
          moviment_date: actual_datetime,
          moviment_description: "Transferência recebida.",
          account_register_id: transfer_moviment.account_register_id_destiny,
          id_moviment_type: @moviment_credit,
          id_operation_type: @operation_transfer
        })
      )
      |> Ecto.Multi.insert(
        :transfer_moviment,
        TransferMoviment.changeset(transfer_moviment, %{
          moviment_amount: transfer_moviment.moviment_amount,
          account_register_id_origin: transfer_moviment.account_register_id_origin,
          account_register_id_destiny: transfer_moviment.account_register_id_destiny
        })
      )
      |> Repo.transaction()
      |> case do
        {:ok, %{transfer_moviment: transfer_moviment}} ->
          {:ok, transfer_moviment}

        {:error, _, reason, _} ->
          {:error, reason}
      end
    end
  end
end
