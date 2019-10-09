defmodule Loany.AccountsTest do
  use Loany.DataCase

  alias Loany.Accounts

  describe "users" do
    alias Loany.Accounts.User

    @valid_attrs %{email: "some email", name: "some name", phone_number: "some phone_number"}
    @update_attrs %{
      email: "some updated email",
      name: "some updated name",
      phone_number: "some updated phone_number"
    }
    @invalid_attrs %{email: nil, name: nil, phone_number: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    # test "get_user!/1 returns the user with given id" do
    #   user = user_fixture()
    #   assert Accounts.get_user!(user.id) == user
    # end

    # test "create_user/1 with valid data creates a user" do
    #   assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
    #   assert user.email == "some email"
    #   assert user.name == "some name"
    #   assert user.phone_number == "some phone_number"
    # end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    # test "change_user/1 returns a user changeset" do
    #   user = user_fixture()
    #   assert %Ecto.Changeset{} = Accounts.change_user(user)
    # end
  end
end
