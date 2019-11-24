defmodule BankWeb.AccountRegisterControllerTest do
  use BankWeb.ConnCase

  alias Bank.Account
  alias Bank.Account.AccountRegister

  @create_attrs %{
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

  def fixture(:account_register) do
    {:ok, account_register} = Account.create_account_register(@create_attrs)
    account_register
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all account_register", %{conn: conn} do
      conn = get(conn, Routes.account_register_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create account_register" do
    test "renders account_register when data is valid", %{conn: conn} do
      conn =
        post(conn, Routes.account_register_path(conn, :create), account_register: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.account_register_path(conn, :show, id))

      assert %{
               "id" => id,
               "account_number" => "some account_number",
               "active" => true,
               "agency_number" => "some agency_number",
               "opening_date" => "2010-04-17"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.account_register_path(conn, :create), account_register: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update account_register" do
    setup [:create_account_register]

    test "renders account_register when data is valid", %{
      conn: conn,
      account_register: %AccountRegister{id: id} = account_register
    } do
      conn =
        put(conn, Routes.account_register_path(conn, :update, account_register),
          account_register: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.account_register_path(conn, :show, id))

      assert %{
               "id" => id,
               "account_number" => "some updated account_number",
               "active" => false,
               "agency_number" => "some updated agency_number",
               "opening_date" => "2011-05-18"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, account_register: account_register} do
      conn =
        put(conn, Routes.account_register_path(conn, :update, account_register),
          account_register: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete account_register" do
    setup [:create_account_register]

    test "deletes chosen account_register", %{conn: conn, account_register: account_register} do
      conn = delete(conn, Routes.account_register_path(conn, :delete, account_register))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.account_register_path(conn, :show, account_register))
      end
    end
  end

  defp create_account_register(_) do
    account_register = fixture(:account_register)
    {:ok, account_register: account_register}
  end
end
