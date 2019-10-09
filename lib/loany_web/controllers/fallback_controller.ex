defmodule LoanyWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.
  """
  use LoanyWeb, :controller

  def call(conn, {:error, :bad_request}) do
    conn
    |> put_flash(:error, "Invalid request parameters.")
    |> redirect(to: "/")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_flash(:error, "Resource not found.")
    |> redirect(to: "/")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_flash(:error, "Bad email/password combination")
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
