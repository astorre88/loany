defmodule Loany.LoansTest do
  use Loany.DataCase

  alias Loany.Loans

  describe "loan_applications" do
    alias Loany.Loans.LoanApplication

    @valid_attrs %{amount: "120.5"}
    @update_attrs %{amount: "456.7"}
    @invalid_attrs %{amount: nil}

    def loan_application_fixture(attrs \\ %{}) do
      {:ok, loan_application} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loans.create_loan_application()

      loan_application
    end

    # test "list_loan_applications/0 returns all loan_applications" do
    #   loan_application = loan_application_fixture()
    #   assert Loans.list_loan_applications() == [loan_application]
    # end

    # test "get_loan_application!/1 returns the loan_application with given id" do
    #   loan_application = loan_application_fixture()
    #   assert Loans.get_loan_application!(loan_application.id) == loan_application
    # end

    # test "create_loan_application/1 with valid data creates a loan_application" do
    #   assert {:ok, %LoanApplication{} = loan_application} =
    #            Loans.create_loan_application(@valid_attrs)

    #   assert loan_application.amount == Decimal.new("120.5")
    # end

    # test "create_loan_application/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Loans.create_loan_application(@invalid_attrs)
    # end

    # test "change_loan_application/1 returns a loan_application changeset" do
    #   loan_application = loan_application_fixture()
    #   assert %Ecto.Changeset{} = Loans.change_loan_application(loan_application)
    # end
  end
end
