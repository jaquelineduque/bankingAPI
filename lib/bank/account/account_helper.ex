defmodule Bank.Account.Helper do
  def get_new_agency_number do
    agency_number = :rand.uniform(9999)

    to_string(agency_number)
    |> String.pad_leading(4, "0")
  end

  def get_new_account_number do
    account_number = :rand.uniform(99_999_999)

    to_string(account_number)
    |> String.pad_leading(8, "0")
  end
end
