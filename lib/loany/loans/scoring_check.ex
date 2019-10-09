defmodule Loany.Loans.ScoringCheck do
  use Memento.Table,
    attributes: [:application_id, :user_id, :amount, :rate],
    index: [:user_id]

  def setup(nodes \\ [node()]) do
    if path = Application.get_env(:mnesia, :dir) do
      :ok = File.mkdir_p!(path)
    end

    Memento.stop()
    Memento.Schema.create(nodes)
    Memento.start()

    Memento.Table.create!(__MODULE__, disc_copies: nodes)
  end

  def all(user_id, requested_amount) do
    execute_query!(fn ->
      Memento.Query.select(__MODULE__, [
        {:==, :user_id, user_id}
      ])
    end)

    execute_query!(fn ->
      Memento.Query.select(__MODULE__, [
        {:==, :user_id, user_id},
        {:>, :amount, requested_amount}
      ])
    end)
  end

  def add(application_id, user_id, amount, rate) do
    execute_query!(fn ->
      Memento.Query.write(%__MODULE__{
        application_id: application_id,
        user_id: user_id,
        amount: amount,
        rate: rate
      })
    end)
  end

  def get(application_id) do
    execute_query!(fn ->
      Memento.Query.read(__MODULE__, application_id)
    end)
  end

  defp execute_query!(fun) do
    Memento.transaction(fun)
    |> case do
      {:error, {:no_exists, __MODULE__}} ->
        raise "#{__MODULE__} table not exists. Run `mix loany.setup` first!"

      result ->
        result
    end
  end
end
