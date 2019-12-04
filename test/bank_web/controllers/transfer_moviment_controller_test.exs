defmodule BankWeb.TransferMovimentControllerTest do
  use BankWeb.ConnCase

  alias Bank.Financial
  alias Bank.Financial.TransferMoviment

  @create_attrs %{
    moviment_amount: "some moviment_amount"
  }
  @update_attrs %{
    moviment_amount: "some updated moviment_amount"
  }
  @invalid_attrs %{moviment_amount: nil}

  def fixture(:transfer_moviment) do
    {:ok, transfer_moviment} = Financial.create_transfer_moviment(@create_attrs)
    transfer_moviment
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all transfer_moviment", %{conn: conn} do
      conn = get(conn, Routes.transfer_moviment_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transfer_moviment" do
    test "renders transfer_moviment when data is valid", %{conn: conn} do
      conn = post(conn, Routes.transfer_moviment_path(conn, :create), transfer_moviment: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.transfer_moviment_path(conn, :show, id))

      assert %{
               "id" => id,
               "moviment_amount" => "some moviment_amount"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transfer_moviment_path(conn, :create), transfer_moviment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update transfer_moviment" do
    setup [:create_transfer_moviment]

    test "renders transfer_moviment when data is valid", %{conn: conn, transfer_moviment: %TransferMoviment{id: id} = transfer_moviment} do
      conn = put(conn, Routes.transfer_moviment_path(conn, :update, transfer_moviment), transfer_moviment: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.transfer_moviment_path(conn, :show, id))

      assert %{
               "id" => id,
               "moviment_amount" => "some updated moviment_amount"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, transfer_moviment: transfer_moviment} do
      conn = put(conn, Routes.transfer_moviment_path(conn, :update, transfer_moviment), transfer_moviment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete transfer_moviment" do
    setup [:create_transfer_moviment]

    test "deletes chosen transfer_moviment", %{conn: conn, transfer_moviment: transfer_moviment} do
      conn = delete(conn, Routes.transfer_moviment_path(conn, :delete, transfer_moviment))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.transfer_moviment_path(conn, :show, transfer_moviment))
      end
    end
  end

  defp create_transfer_moviment(_) do
    transfer_moviment = fixture(:transfer_moviment)
    {:ok, transfer_moviment: transfer_moviment}
  end
end
