defmodule LoanyWeb.ApplicationChannel do
  use Phoenix.Channel

  def join("application:" <> worker_id, _params, socket) do
    IO.inspect(worker_id, label: "WORKER_ID")
    {:ok, assign(socket, :worker_id, worker_id)}
  end
end
