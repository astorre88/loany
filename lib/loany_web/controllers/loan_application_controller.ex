defmodule LoanyWeb.LoanApplicationController do
  use LoanyWeb, :controller

  alias Loany.Loans
  alias Loany.Loans.LoanApplication

  @default_currency Application.get_env(:money, :default_currency)

  action_fallback(LoanyWeb.FallbackController)

  plug :logged_in_user when action in [:index, :show]
  plug :admin_user when action in [:index, :show]

  def index(conn, _params) do
    loan_applications = Loans.list_loan_applications()
    render(conn, "index.html", loan_applications: loan_applications)
  end

  def new(conn, _params) do
    changeset = Loans.change_loan_application(%LoanApplication{})
    render(conn, "new.html", changeset: changeset, default_currency: @default_currency)
  end

  def create(conn, %{"loan_application" => loan_application_params}) do
    with {:ok,
          %LoanApplication{
            amount: %Money{amount: amount},
            user: %{name: name, phone_number: phone_number, email: email}
          }, worker_id_number} <- Loans.apply_and_check_rate(loan_application_params) do
      conn
      |> put_flash(:info, "Loan application created successfully.")
      |> redirect(
        to:
          Routes.loan_application_path(conn, :notify,
            amount: amount,
            name: name,
            phone_number: phone_number,
            email: email,
            worker_id: worker_id_number
          )
      )
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)

      error ->
        error
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, loan_application, interest_rate} <- Loans.get_loan_application_with_rate(id) do
      render(conn, "show.html", loan_application: loan_application, interest_rate: interest_rate)
    end
  end

  def notify(conn, %{
        "amount" => amount,
        "email" => email,
        "name" => name,
        "phone_number" => phone_number,
        "worker_id" => worker_id
      }) do
    worker_pid =
      try do
        :erlang.list_to_pid('<#{worker_id}>')
      rescue
        _ ->
          conn
          |> put_flash(:error, "Invalid request parameters.")
          |> redirect(to: "/")
      end

    with true <- is_pid(worker_pid),
         true <- Process.alive?(worker_pid),
         {amount, ""} <- Integer.parse(amount),
         rate <- Loans.get_rate(worker_pid) do
      render(conn, "notify.html",
        amount: amount,
        email: email,
        name: name,
        phone_number: phone_number,
        rate: rate,
        worker_id: worker_id
      )
    else
      _ -> {:error, :bad_request}
    end
  end
end
