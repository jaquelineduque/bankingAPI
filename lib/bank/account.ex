defmodule Bank.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias Bank.Repo

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
end
