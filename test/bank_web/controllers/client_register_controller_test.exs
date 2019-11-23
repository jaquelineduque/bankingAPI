defmodule BankWeb.ClientRegisterControllerTest do
  use BankWeb.ConnCase

  alias Bank.Account
  alias Bank.Account.ClientRegister

  @create_attrs %{
    cpf: "some cpf",
    date_of_birth: ~D[2010-04-17],
    name: "some name"
  }
  @update_attrs %{
    cpf: "some updated cpf",
    date_of_birth: ~D[2011-05-18],
    name: "some updated name"
  }
  @invalid_attrs %{cpf: nil, date_of_birth: nil, name: nil}

  def fixture(:client_register) do
    {:ok, client_register} = Account.create_client_register(@create_attrs)
    client_register
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all client_register", %{conn: conn} do
      conn = get(conn, Routes.client_register_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create client_register" do
    test "renders client_register when data is valid", %{conn: conn} do
      conn = post(conn, Routes.client_register_path(conn, :create), client_register: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.client_register_path(conn, :show, id))

      assert %{
               "id" => id,
               "cpf" => "some cpf",
               "date_of_birth" => "2010-04-17",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.client_register_path(conn, :create), client_register: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update client_register" do
    setup [:create_client_register]

    test "renders client_register when data is valid", %{conn: conn, client_register: %ClientRegister{id: id} = client_register} do
      conn = put(conn, Routes.client_register_path(conn, :update, client_register), client_register: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.client_register_path(conn, :show, id))

      assert %{
               "id" => id,
               "cpf" => "some updated cpf",
               "date_of_birth" => "2011-05-18",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, client_register: client_register} do
      conn = put(conn, Routes.client_register_path(conn, :update, client_register), client_register: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete client_register" do
    setup [:create_client_register]

    test "deletes chosen client_register", %{conn: conn, client_register: client_register} do
      conn = delete(conn, Routes.client_register_path(conn, :delete, client_register))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.client_register_path(conn, :show, client_register))
      end
    end
  end

  defp create_client_register(_) do
    client_register = fixture(:client_register)
    {:ok, client_register: client_register}
  end
end
