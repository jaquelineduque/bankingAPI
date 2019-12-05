defmodule Bank.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias Bank.Repo
  alias Bank.Account.AccountBalance, as: AccountBalance
  alias Bank.Account.AccountRegister, as: AccountRegister

  alias Bank.Account.ClientRegister

  @doc """
  Returns the list of client_register.

  ## Examples

      iex> list_client_register()
      [%ClientRegister{}, ...]

  """
  def list_client_register do
    Repo.all(ClientRegister)
  end

  @doc """
  Gets a single client_register.

  Raises `Ecto.NoResultsError` if the Client register does not exist.

  ## Examples

      iex> get_client_register!(123)
      %ClientRegister{}

      iex> get_client_register!(456)
      ** (Ecto.NoResultsError)

  """
  def get_client_register!(id), do: Repo.get!(ClientRegister, id)

  @doc """
  Creates a client_register.

  ## Examples

      iex> create_client_register(%{field: value})
      {:ok, %ClientRegister{}}

      iex> create_client_register(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_client_register(attrs \\ %{}) do
    %ClientRegister{}
    |> ClientRegister.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a client_register.

  ## Examples

      iex> update_client_register(client_register, %{field: new_value})
      {:ok, %ClientRegister{}}

      iex> update_client_register(client_register, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_client_register(%ClientRegister{} = client_register, attrs) do
    client_register
    |> ClientRegister.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ClientRegister.

  ## Examples

      iex> delete_client_register(client_register)
      {:ok, %ClientRegister{}}

      iex> delete_client_register(client_register)
      {:error, %Ecto.Changeset{}}

  """
  def delete_client_register(%ClientRegister{} = client_register) do
    Repo.delete(client_register)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking client_register changes.

  ## Examples

      iex> change_client_register(client_register)
      %Ecto.Changeset{source: %ClientRegister{}}

  """
  def change_client_register(%ClientRegister{} = client_register) do
    ClientRegister.changeset(client_register, %{})
  end

  alias Bank.Account.AccountRegister

  @doc """
  Returns the list of account_register.

  ## Examples

      iex> list_account_register()
      [%AccountRegister{}, ...]

  """
  def list_account_register do
    Repo.all(AccountRegister)
  end

  @doc """
  Checks if account exists.
  """

  def account_exists(id) do
    Repo.exists?(from a in AccountRegister, where: a.id == ^id)
  end

  @doc """
  Gets a single account_register.

  Raises `Ecto.NoResultsError` if the Account register does not exist.

  ## Examples

      iex> get_account_register!(123)
      %AccountRegister{}

      iex> get_account_register!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account_register!(id), do: Repo.get!(AccountRegister, id)

  @doc """
  Creates a account_register.

  ## Examples

      iex> create_account_register(%{field: value})
      {:ok, %AccountRegister{}}

      iex> create_account_register(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account_register(attrs \\ %{}) do
    %AccountRegister{}
    |> AccountRegister.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account_register.

  ## Examples

      iex> update_account_register(account_register, %{field: new_value})
      {:ok, %AccountRegister{}}

      iex> update_account_register(account_register, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account_register(%AccountRegister{} = account_register, attrs) do
    account_register
    |> AccountRegister.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a AccountRegister.

  ## Examples

      iex> delete_account_register(account_register)
      {:ok, %AccountRegister{}}

      iex> delete_account_register(account_register)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account_register(%AccountRegister{} = account_register) do
    Repo.delete(account_register)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account_register changes.

  ## Examples

      iex> change_account_register(account_register)
      %Ecto.Changeset{source: %AccountRegister{}}

  """
  def change_account_register(%AccountRegister{} = account_register) do
    AccountRegister.changeset(account_register, %{})
  end

  alias Bank.Account.AccountBalance

  @doc """
  Returns the list of account_balance.

  ## Examples

      iex> list_account_balance()
      [%AccountBalance{}, ...]

  """
  def list_account_balance do
    Repo.all(AccountBalance)
  end

  @doc """
  Gets a single account_balance.

  Raises `Ecto.NoResultsError` if the Account balance does not exist.

  ## Examples

      iex> get_account_balance!(123)
      %AccountBalance{}

      iex> get_account_balance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account_balance!(id), do: Repo.get!(AccountBalance, id)

  @doc """
  Checks if balance exists.
  """

  def account_has_balance(id) do
    Repo.exists?(
      from a in AccountRegister,
        join: b in AccountBalance,
        on: a.id == b.account_register_id,
        where: a.id == ^id
    )
  end

  @doc """
  Creates a account_balance.

  ## Examples

      iex> create_account_balance(%{field: value})
      {:ok, %AccountBalance{}}

      iex> create_account_balance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account_balance(attrs \\ %{}) do
    %AccountBalance{}
    |> AccountBalance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account_balance.

  ## Examples

      iex> update_account_balance(account_balance, %{field: new_value})
      {:ok, %AccountBalance{}}

      iex> update_account_balance(account_balance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account_balance(%AccountBalance{} = account_balance, attrs) do
    account_balance
    |> AccountBalance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a AccountBalance.

  ## Examples

      iex> delete_account_balance(account_balance)
      {:ok, %AccountBalance{}}

      iex> delete_account_balance(account_balance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account_balance(%AccountBalance{} = account_balance) do
    Repo.delete(account_balance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account_balance changes.

  ## Examples

      iex> change_account_balance(account_balance)
      %Ecto.Changeset{source: %AccountBalance{}}

  """
  def change_account_balance(%AccountBalance{} = account_balance) do
    AccountBalance.changeset(account_balance, %{})
  end

  def activate_account_register(%AccountRegister{} = account_register) do
    actual_date = Date.utc_today()

    account_register = Bank.Repo.get!(AccountRegister, account_register.id)

    balance_register = %AccountBalance{}

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :account_balance,
      AccountBalance.changeset(balance_register, %{
        account_register_id: account_register.id,
        balance_amount: 1000
      })
    )
    |> Ecto.Multi.update(
      :account_register,
      AccountRegister.changeset(account_register, %{
        active: true,
        opening_date: actual_date,
        user_id: account_register.user_id
      })
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{account_register: account_register}} ->
        {:ok, account_register}

      {:error, _, reason, _} ->
        {:error, reason}
    end
  end

  def get_account_balance(account_register_id) do
    Repo.get_by!(AccountBalance, account_register_id: account_register_id)
  end

  def is_account_active(id) do
    account_register = get_account_register!(id)
    account_register.active
  end
end
