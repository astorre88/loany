defmodule Loany.Repo do
  use Ecto.Repo,
    otp_app: :loany,
    adapter: Ecto.Adapters.Postgres
end
