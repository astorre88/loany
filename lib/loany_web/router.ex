defmodule LoanyWeb.Router do
  use LoanyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Loany.Auth
  end

  scope "/", LoanyWeb do
    pipe_through :browser

    get "/", LoanApplicationController, :new
    get "/signin", SessionController, :new
    get "/signout", SessionController, :delete
    get "/notify", LoanApplicationController, :notify
    resources "/applications", LoanApplicationController, only: [:index, :show, :new, :create]
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete], singleton: true
  end
end
