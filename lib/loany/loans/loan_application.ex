defmodule Loany.Loans.LoanApplication do
  use Ecto.Schema
  import Ecto.Changeset

  schema "loan_applications" do
    field :amount, Money.Ecto.Amount.Type
    belongs_to :user, Loany.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(loan_application, attrs) do
    loan_application
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
    |> validate_number(:amount, greater_than: 0)
    |> wrap_amount()
  end

  defp wrap_amount(%Ecto.Changeset{changes: %{amount: amount}} = changeset) do
    put_change(changeset, :amount, Money.new(amount))
  end

  defp wrap_amount(changeset), do: changeset
end
