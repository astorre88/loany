defmodule LoanyWeb.LoanApplicationControllerTest do
  use LoanyWeb.ConnCase

  alias Loany.Loans

  @create_attrs %{amount: "120.5"}
  @update_attrs %{amount: "456.7"}
  @invalid_attrs %{amount: -1}

  def fixture(:loan_application) do
    {:ok, loan_application} = Loans.create_loan_application(@create_attrs)
    loan_application
  end

  describe "new loan_application" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.loan_application_path(conn, :new))
      assert html_response(conn, 200) =~ "New Loan application"
    end
  end

  describe "create loan_application" do
    # test "redirects to show when data is valid", %{conn: conn} do
    #   conn = post(conn, Routes.loan_application_path(conn, :create), loan_application: @create_attrs)

    #   assert %{id: id} = redirected_params(conn)
    #   assert redirected_to(conn) == Routes.loan_application_path(conn, :show, id)

    #   conn = get(conn, Routes.loan_application_path(conn, :show, id))
    #   assert html_response(conn, 200) =~ "Show Loan application"
    # end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn =
    #     post(conn, Routes.loan_application_path(conn, :create), loan_application: @invalid_attrs)

    #   assert html_response(conn, 200) =~ "New Loan application"
    # end
  end

  defp create_loan_application(_) do
    loan_application = fixture(:loan_application)
    {:ok, loan_application: loan_application}
  end
end
