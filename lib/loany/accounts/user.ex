defmodule Loany.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  @iso_digits "SE"

  schema "users" do
    field :email, :string
    field :name, :string
    field :phone_number, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :is_admin, :boolean
    has_many :loan_applications, Loany.Loans.LoanApplication

    timestamps()
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:name, :phone_number, :email])
    |> validate_required([:name, :phone_number, :email])
    |> validate_length(:name, max: 255)
    |> validate_change(:phone_number, &validate/2)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:email, max: 255)
    |> unique_constraint(:email)
  end

  def registration_changeset(user, attrs \\ %{}) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password, :password_confirmation, :is_admin])
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> hash_password()
  end

  defp hash_password(%{valid?: false} = changeset), do: changeset

  defp hash_password(%{valid?: true, changes: %{password: pass}} = changeset) do
    change(changeset, Argon2.add_hash(pass))
  end

  defp validate(:phone_number, phone_number) do
    with {:ok, phone_number} <- ExPhoneNumber.parse(phone_number, @iso_digits),
         true <- ExPhoneNumber.is_valid_number?(phone_number) do
      []
    else
      _ -> [phone_number: "phone_number is invalid"]
    end
  end
end
