defmodule Bank.AccountTest do
  use Bank.DataCase

  alias Bank.Account

  describe "client_register" do
    alias Bank.Account.ClientRegister

    @valid_attrs %{cpf: "some cpf", date_of_birth: ~D[2010-04-17], name: "some name"}
    @update_attrs %{
      cpf: "some updated cpf",
      date_of_birth: ~D[2011-05-18],
      name: "some updated name"
    }
    @invalid_attrs %{cpf: nil, date_of_birth: nil, name: nil}

    def client_register_fixture(attrs \\ %{}) do
      {:ok, client_register} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_client_register()

      client_register
    end

    test "list_client_register/0 returns all client_register" do
      client_register = client_register_fixture()
      assert Account.list_client_register() == [client_register]
    end

    test "get_client_register!/1 returns the client_register with given id" do
      client_register = client_register_fixture()
      assert Account.get_client_register!(client_register.id) == client_register
    end

    test "create_client_register/1 with valid data creates a client_register" do
      assert {:ok, %ClientRegister{} = client_register} =
               Account.create_client_register(@valid_attrs)

      assert client_register.cpf == "some cpf"
      assert client_register.date_of_birth == ~D[2010-04-17]
      assert client_register.name == "some name"
    end

    test "create_client_register/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_client_register(@invalid_attrs)
    end

    test "update_client_register/2 with valid data updates the client_register" do
      client_register = client_register_fixture()

      assert {:ok, %ClientRegister{} = client_register} =
               Account.update_client_register(client_register, @update_attrs)

      assert client_register.cpf == "some updated cpf"
      assert client_register.date_of_birth == ~D[2011-05-18]
      assert client_register.name == "some updated name"
    end

    test "update_client_register/2 with invalid data returns error changeset" do
      client_register = client_register_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Account.update_client_register(client_register, @invalid_attrs)

      assert client_register == Account.get_client_register!(client_register.id)
    end

    test "delete_client_register/1 deletes the client_register" do
      client_register = client_register_fixture()
      assert {:ok, %ClientRegister{}} = Account.delete_client_register(client_register)
      assert_raise Ecto.NoResultsError, fn -> Account.get_client_register!(client_register.id) end
    end

    test "change_client_register/1 returns a client_register changeset" do
      client_register = client_register_fixture()
      assert %Ecto.Changeset{} = Account.change_client_register(client_register)
    end
  end

  describe "account_register" do
    alias Bank.Account.AccountRegister

    @valid_attrs %{
      account_number: "some account_number",
      active: true,
      agency_number: "some agency_number",
      opening_date: ~D[2010-04-17]
    }
    @update_attrs %{
      account_number: "some updated account_number",
      active: false,
      agency_number: "some updated agency_number",
      opening_date: ~D[2011-05-18]
    }
    @invalid_attrs %{account_number: nil, active: nil, agency_number: nil, opening_date: nil}

    def account_register_fixture(attrs \\ %{}) do
      {:ok, account_register} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_account_register()

      account_register
    end

    test "list_account_register/0 returns all account_register" do
      account_register = account_register_fixture()
      assert Account.list_account_register() == [account_register]
    end

    test "get_account_register!/1 returns the account_register with given id" do
      account_register = account_register_fixture()
      assert Account.get_account_register!(account_register.id) == account_register
    end

    test "create_account_register/1 with valid data creates a account_register" do
      assert {:ok, %AccountRegister{} = account_register} =
               Account.create_account_register(@valid_attrs)

      assert account_register.account_number == "some account_number"
      assert account_register.active == true
      assert account_register.agency_number == "some agency_number"
      assert account_register.opening_date == ~D[2010-04-17]
    end

    test "create_account_register/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_account_register(@invalid_attrs)
    end

    test "update_account_register/2 with valid data updates the account_register" do
      account_register = account_register_fixture()

      assert {:ok, %AccountRegister{} = account_register} =
               Account.update_account_register(account_register, @update_attrs)

      assert account_register.account_number == "some updated account_number"
      assert account_register.active == false
      assert account_register.agency_number == "some updated agency_number"
      assert account_register.opening_date == ~D[2011-05-18]
    end

    test "update_account_register/2 with invalid data returns error changeset" do
      account_register = account_register_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Account.update_account_register(account_register, @invalid_attrs)

      assert account_register == Account.get_account_register!(account_register.id)
    end

    test "delete_account_register/1 deletes the account_register" do
      account_register = account_register_fixture()
      assert {:ok, %AccountRegister{}} = Account.delete_account_register(account_register)

      assert_raise Ecto.NoResultsError, fn ->
        Account.get_account_register!(account_register.id)
      end
    end

    test "change_account_register/1 returns a account_register changeset" do
      account_register = account_register_fixture()
      assert %Ecto.Changeset{} = Account.change_account_register(account_register)
    end
  end

  describe "account_balance" do
    alias Bank.Account.AccountBalance

    @valid_attrs %{balance_amount: "120.5"}
    @update_attrs %{balance_amount: "456.7"}
    @invalid_attrs %{balance_amount: nil}

    def account_balance_fixture(attrs \\ %{}) do
      {:ok, account_balance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_account_balance()

      account_balance
    end

    test "list_account_balance/0 returns all account_balance" do
      account_balance = account_balance_fixture()
      assert Account.list_account_balance() == [account_balance]
    end

    test "get_account_balance!/1 returns the account_balance with given id" do
      account_balance = account_balance_fixture()
      assert Account.get_account_balance!(account_balance.id) == account_balance
    end

    test "create_account_balance/1 with valid data creates a account_balance" do
      assert {:ok, %AccountBalance{} = account_balance} = Account.create_account_balance(@valid_attrs)
      assert account_balance.balance_amount == Decimal.new("120.5")
    end

    test "create_account_balance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_account_balance(@invalid_attrs)
    end

    test "update_account_balance/2 with valid data updates the account_balance" do
      account_balance = account_balance_fixture()
      assert {:ok, %AccountBalance{} = account_balance} = Account.update_account_balance(account_balance, @update_attrs)
      assert account_balance.balance_amount == Decimal.new("456.7")
    end

    test "update_account_balance/2 with invalid data returns error changeset" do
      account_balance = account_balance_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_account_balance(account_balance, @invalid_attrs)
      assert account_balance == Account.get_account_balance!(account_balance.id)
    end

    test "delete_account_balance/1 deletes the account_balance" do
      account_balance = account_balance_fixture()
      assert {:ok, %AccountBalance{}} = Account.delete_account_balance(account_balance)
      assert_raise Ecto.NoResultsError, fn -> Account.get_account_balance!(account_balance.id) end
    end

    test "change_account_balance/1 returns a account_balance changeset" do
      account_balance = account_balance_fixture()
      assert %Ecto.Changeset{} = Account.change_account_balance(account_balance)
    end
  end
end
