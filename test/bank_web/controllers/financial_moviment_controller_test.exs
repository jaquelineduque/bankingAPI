defmodule BankWeb.FinancialMovimentControllerTest do
  use BankWeb.ConnCase

  alias Bank.Financial
  alias Bank.Financial.FinancialMoviment

  @create_attrs %{
    moviment_amount: "120.5",
    moviment_date: ~N[2010-04-17 14:00:00.000000],
    moviment_description: "some moviment_description"
  }
  @update_attrs %{
    moviment_amount: "456.7",
    moviment_date: ~N[2011-05-18 15:01:01.000000],
    moviment_description: "some updated moviment_description"
  }
  @invalid_attrs %{moviment_amount: nil, moviment_date: nil, moviment_description: nil}

  def fixture(:financial_moviment) do
    {:ok, financial_moviment} = Financial.create_financial_moviment(@create_attrs)
    financial_moviment
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all financial_moviment", %{conn: conn} do
      conn = get(conn, Routes.financial_moviment_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create financial_moviment" do
    test "renders financial_moviment when data is valid", %{conn: conn} do
      conn = post(conn, Routes.financial_moviment_path(conn, :create), financial_moviment: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.financial_moviment_path(conn, :show, id))

      assert %{
               "id" => id,
               "moviment_amount" => "120.5",
               "moviment_date" => "2010-04-17T14:00:00.000000",
               "moviment_description" => "some moviment_description"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.financial_moviment_path(conn, :create), financial_moviment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update financial_moviment" do
    setup [:create_financial_moviment]

    test "renders financial_moviment when data is valid", %{conn: conn, financial_moviment: %FinancialMoviment{id: id} = financial_moviment} do
      conn = put(conn, Routes.financial_moviment_path(conn, :update, financial_moviment), financial_moviment: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.financial_moviment_path(conn, :show, id))

      assert %{
               "id" => id,
               "moviment_amount" => "456.7",
               "moviment_date" => "2011-05-18T15:01:01.000000",
               "moviment_description" => "some updated moviment_description"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, financial_moviment: financial_moviment} do
      conn = put(conn, Routes.financial_moviment_path(conn, :update, financial_moviment), financial_moviment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete financial_moviment" do
    setup [:create_financial_moviment]

    test "deletes chosen financial_moviment", %{conn: conn, financial_moviment: financial_moviment} do
      conn = delete(conn, Routes.financial_moviment_path(conn, :delete, financial_moviment))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.financial_moviment_path(conn, :show, financial_moviment))
      end
    end
  end

  defp create_financial_moviment(_) do
    financial_moviment = fixture(:financial_moviment)
    {:ok, financial_moviment: financial_moviment}
  end
end
