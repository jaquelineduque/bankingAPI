defmodule BankWeb.TransferMovimentView do
  use BankWeb, :view
  alias BankWeb.TransferMovimentView

  def render("index.json", %{transfer_moviment: transfer_moviment}) do
    %{data: render_many(transfer_moviment, TransferMovimentView, "transfer_moviment.json")}
  end

  def render("show.json", %{transfer_moviment: transfer_moviment}) do
    %{data: render_one(transfer_moviment, TransferMovimentView, "transfer_moviment.json")}
  end

  def render("transfer_moviment.json", %{transfer_moviment: transfer_moviment}) do
    %{id: transfer_moviment.id,
      moviment_amount: transfer_moviment.moviment_amount}
  end
end
