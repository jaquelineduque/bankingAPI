defmodule Bank.FinancialTest do
  use Bank.DataCase

  alias Bank.Financial

  describe "financial_moviment" do
    alias Bank.Financial.FinancialMoviment

    @valid_attrs %{moviment_amount: "120.5", moviment_date: ~N[2010-04-17 14:00:00.000000], moviment_description: "some moviment_description"}
    @update_attrs %{moviment_amount: "456.7", moviment_date: ~N[2011-05-18 15:01:01.000000], moviment_description: "some updated moviment_description"}
    @invalid_attrs %{moviment_amount: nil, moviment_date: nil, moviment_description: nil}

    def financial_moviment_fixture(attrs \\ %{}) do
      {:ok, financial_moviment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Financial.create_financial_moviment()

      financial_moviment
    end

    test "list_financial_moviment/0 returns all financial_moviment" do
      financial_moviment = financial_moviment_fixture()
      assert Financial.list_financial_moviment() == [financial_moviment]
    end

    test "get_financial_moviment!/1 returns the financial_moviment with given id" do
      financial_moviment = financial_moviment_fixture()
      assert Financial.get_financial_moviment!(financial_moviment.id) == financial_moviment
    end

    test "create_financial_moviment/1 with valid data creates a financial_moviment" do
      assert {:ok, %FinancialMoviment{} = financial_moviment} = Financial.create_financial_moviment(@valid_attrs)
      assert financial_moviment.moviment_amount == Decimal.new("120.5")
      assert financial_moviment.moviment_date == ~N[2010-04-17 14:00:00.000000]
      assert financial_moviment.moviment_description == "some moviment_description"
    end

    test "create_financial_moviment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Financial.create_financial_moviment(@invalid_attrs)
    end

    test "update_financial_moviment/2 with valid data updates the financial_moviment" do
      financial_moviment = financial_moviment_fixture()
      assert {:ok, %FinancialMoviment{} = financial_moviment} = Financial.update_financial_moviment(financial_moviment, @update_attrs)
      assert financial_moviment.moviment_amount == Decimal.new("456.7")
      assert financial_moviment.moviment_date == ~N[2011-05-18 15:01:01.000000]
      assert financial_moviment.moviment_description == "some updated moviment_description"
    end

    test "update_financial_moviment/2 with invalid data returns error changeset" do
      financial_moviment = financial_moviment_fixture()
      assert {:error, %Ecto.Changeset{}} = Financial.update_financial_moviment(financial_moviment, @invalid_attrs)
      assert financial_moviment == Financial.get_financial_moviment!(financial_moviment.id)
    end

    test "delete_financial_moviment/1 deletes the financial_moviment" do
      financial_moviment = financial_moviment_fixture()
      assert {:ok, %FinancialMoviment{}} = Financial.delete_financial_moviment(financial_moviment)
      assert_raise Ecto.NoResultsError, fn -> Financial.get_financial_moviment!(financial_moviment.id) end
    end

    test "change_financial_moviment/1 returns a financial_moviment changeset" do
      financial_moviment = financial_moviment_fixture()
      assert %Ecto.Changeset{} = Financial.change_financial_moviment(financial_moviment)
    end
  end
end
