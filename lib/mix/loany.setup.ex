defmodule Mix.Tasks.Loany.Setup do
  use Mix.Task

  @moduledoc """
  Creates an Mnesia DB on disk for Loany scoring mechanism.
  """

  @doc """
  Setups persistence back.
  """
  def run(_) do
    Loany.Loans.ScoringCheck.setup()
  end
end
