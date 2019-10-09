defmodule LoanyWeb.SessionController do
  use LoanyWeb, :controller

  alias Loany.Accounts

  action_fallback(LoanyWeb.FallbackController)

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    with {:ok, user} <- Accounts.authenticate_by_email_password(email, password) do
      conn
      |> put_flash(:info, "User successfully logged in")
      |> put_session(:user_id, user.id)
      |> configure_session(renew: true)
      |> redirect(to: Routes.loan_application_path(conn, :index))
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:success, "Successfuly signed out")
    |> redirect(to: "/")
  end
end
