defmodule Loany.Repo.Migrations.CreateLoanApplications do
  use Ecto.Migration

  def change do
    create table(:loan_applications) do
      add :amount, :bigint, null: false
      add :user_id, references(:users)

      timestamps()
    end

    create index(:loan_applications, [:user_id])
  end
end
