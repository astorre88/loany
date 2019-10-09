defmodule LoanyWeb.UserControllerTest do
  use LoanyWeb.ConnCase

  alias Loany.Accounts

  @create_attrs %{email: "some email", name: "some name", phone_number: "some phone_number"}
  @update_attrs %{
    email: "some updated email",
    name: "some updated name",
    phone_number: "some updated phone_number"
  }
  @invalid_attrs %{email: nil, name: nil, phone_number: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "new user" do
    # test "renders form", %{conn: conn} do
    #   conn = get(conn, Routes.user_path(conn, :new))
    #   assert html_response(conn, 200) =~ "New User"
    # end
  end

  describe "create user" do
    # test "redirects to show when data is valid", %{conn: conn} do
    #   conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

    #   assert %{id: id} = redirected_params(conn)
    #   assert redirected_to(conn) == Routes.user_path(conn, :show, id)

    #   conn = get(conn, Routes.user_path(conn, :show, id))
    #   assert html_response(conn, 200) =~ "Show User"
    # end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
    #   assert html_response(conn, 200) =~ "New User"
    # end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
