defmodule Loany.Loans do
  @moduledoc """
  The Loans context.
  """

  import Ecto.Query, warn: false
  alias Loany.Repo

  alias Loany.Accounts
  alias Loany.Accounts.User
  alias Loany.Loans.{LoanApplication, ScoringCheck}

  @default_currency Application.get_env(:money, :default_currency)

  @doc """
  Returns the list of loan_applications.

  ## Examples

      iex> list_loan_applications()
      [%LoanApplication{}, ...]

  """
  def list_loan_applications do
    LoanApplication
    |> order_by([a], desc: a.inserted_at)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single loan_application.

  Raises `Ecto.NoResultsError` if the Loan application does not exist.

  ## Examples

      iex> get_loan_application(123)
      %LoanApplication{}

      iex> get_loan_application(456)
      nil

  """
  def get_loan_application(id) do
    LoanApplication
    |> Repo.get(id)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single loan_application with evaluated loan rate.

  """
  def get_loan_application_with_rate(id) do
    with %LoanApplication{id: application_id, user_id: user_id} = loan_application <-
           get_loan_application(id),
         {:ok, %ScoringCheck{rate: rate, user_id: ^user_id, application_id: ^application_id}} <-
           ScoringCheck.get(application_id) do
      {:ok, loan_application, rate}
    else
      _ -> {:error, :not_found}
    end
  end

  @doc """
  Creates a loan_application.

  ## Examples

      iex> create_loan_application(%{field: value})
      {:ok, %LoanApplication{}}

      iex> create_loan_application(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_application(%{"user" => %{"email" => email} = user_attrs} = attrs) do
    user =
      case Accounts.get_user_by(email: email) do
        nil ->
          User.changeset(%User{}, user_attrs)

        user ->
          user
      end

    %LoanApplication{}
    |> LoanApplication.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def create_loan_application(_), do: {:error, :bad_request}

  @doc """
  Fetches a loan rate.

  """
  def get_rate(pid) do
    Loany.ScoringWorker.get_rate(pid)
  end

  @doc """
  Creates a loan application and starts check with loan rate evaluating.

  """
  def apply_and_check_rate(attrs) do
    with {:ok,
          %LoanApplication{id: application_id, user_id: user_id, amount: amount} =
            loan_application} <-
           create_loan_application(attrs),
         {:ok, worker_id} <- start_check_application(application_id, user_id, amount) do
      worker_id_number =
        worker_id
        |> inspect()
        |> String.slice(5..-2)

      {:ok, loan_application, worker_id_number}
    else
      _ ->
        {:error, :bad_request}
    end
  end

  defp start_check_application(application_id, user_id, %Money{
         amount: requested_amount,
         currency: @default_currency
       }) do
    DynamicSupervisor.start_child(
      Loany.ScoringSupervisor,
      {Loany.ScoringWorker,
       application_id: application_id, user_id: user_id, requested_amount: requested_amount}
    )
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_application changes.

  ## Examples

      iex> change_loan_application(loan_application)
      %Ecto.Changeset{source: %LoanApplication{}}

  """
  def change_loan_application(%LoanApplication{} = loan_application) do
    LoanApplication.changeset(loan_application, %{})
  end
end
