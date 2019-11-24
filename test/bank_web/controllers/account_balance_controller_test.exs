defmodule BankWeb.AccountBalanceControllerTest do
  use BankWeb.ConnCase

  alias Bank.Account
  alias Bank.Account.AccountBalance

  @create_attrs %{
    balance_amount: "120.5"
  }
  @update_attrs %{
    balance_amount: "456.7"
  }
  @invalid_attrs %{balance_amount: nil}

  def fixture(:account_balance) do
    {:ok, account_balance} = Account.create_account_balance(@create_attrs)
    account_balance
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all account_balance", %{conn: conn} do
      conn = get(conn, Routes.account_balance_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create account_balance" do
    test "renders account_balance when data is valid", %{conn: conn} do
      conn = post(conn, Routes.account_balance_path(conn, :create), account_balance: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.account_balance_path(conn, :show, id))

      assert %{
               "id" => id,
               "balance_amount" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.account_balance_path(conn, :create), account_balance: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update account_balance" do
    setup [:create_account_balance]

    test "renders account_balance when data is valid", %{conn: conn, account_balance: %AccountBalance{id: id} = account_balance} do
      conn = put(conn, Routes.account_balance_path(conn, :update, account_balance), account_balance: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.account_balance_path(conn, :show, id))

      assert %{
               "id" => id,
               "balance_amount" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, account_balance: account_balance} do
      conn = put(conn, Routes.account_balance_path(conn, :update, account_balance), account_balance: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete account_balance" do
    setup [:create_account_balance]

    test "deletes chosen account_balance", %{conn: conn, account_balance: account_balance} do
      conn = delete(conn, Routes.account_balance_path(conn, :delete, account_balance))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.account_balance_path(conn, :show, account_balance))
      end
    end
  end

  defp create_account_balance(_) do
    account_balance = fixture(:account_balance)
    {:ok, account_balance: account_balance}
  end
end
