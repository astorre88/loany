defmodule Loany.ScoringWorker do
  @moduledoc """
  Scoring mechanism
  """

  use GenServer

  require Logger

  alias Loany.Scoring.InterestRate
  alias Loany.Scoring.Numbers
  alias Loany.Loans.ScoringCheck

  @prime_rate 9.99
  # 1 hour
  @work_time 60 * 60 * 1000

  defmodule State do
    @moduledoc false
    @enforce_keys [:application_id, :user_id, :requested_amount]
    defstruct [:application_id, :user_id, :requested_amount]
  end

  # API

  def start_link(application_data) do
    GenServer.start_link(__MODULE__, struct(State, application_data),
      name: :"Worker#{application_data[:application_id]}"
    )
  end

  def get_rate(pid) do
    GenServer.call(pid, :get_rate)
  end

  # Server

  @impl true
  def init(
        %{application_id: application_id, user_id: user_id, requested_amount: requested_amount} =
          application_data
      ) do
    send(self(), {:evaluate, application_id, user_id, requested_amount})
    {:ok, application_data}
  end

  @impl true
  def handle_info({:evaluate, application_id, user_id, requested_amount}, application_data) do
    rate =
      case lower_than_previous?(user_id, requested_amount) do
        {:ok, true} ->
          if Numbers.is_prime?(requested_amount) do
            Logger.info("Requested amount #{requested_amount} is prime")
            save_and_broadcast(application_id, user_id, requested_amount, @prime_rate)
            @prime_rate
          else
            generated_rate = InterestRate.generate()
            Logger.info("Generated #{generated_rate}% rate")
            save_and_broadcast(application_id, user_id, requested_amount, generated_rate)
            generated_rate
          end

        {:ok, false} ->
          Logger.info("Application rejected")
          save_and_broadcast(application_id, user_id, requested_amount, 0)
          0

        error ->
          Logger.error("Evaluation error: #{error}")
          -1
      end

    {:noreply, application_data |> Map.put(:rate, rate)}
  end

  @impl true
  def handle_info(:finish_work, application_data) do
    {:stop, :normal, application_data}
  end

  @impl true
  def handle_call(:get_rate, _from, %{rate: rate} = application_data) do
    {:reply, rate, application_data}
  end

  @impl true
  def handle_call(:get_rate, _from, application_data) do
    {:reply, -1, application_data}
  end

  defp save_and_broadcast(application_id, user_id, requested_amount, rate) do
    ScoringCheck.add(application_id, user_id, requested_amount, rate)

    self()
    |> inspect()
    |> String.slice(5..-2)
    |> (&"application:#{&1}").()
    |> LoanyWeb.Endpoint.broadcast!("scoring_check_result", %{rate: rate})

    Process.send_after(self(), :finish_work, @work_time)
  end

  defp lower_than_previous?(user_id, requested_amount) do
    user_id
    |> ScoringCheck.all(requested_amount)
    |> case do
      {:ok, result} when is_list(result) ->
        {:ok, Enum.empty?(result)}

      {:ok, _} ->
        {:error, :bad_result}

      error ->
        error
    end
  end
end
