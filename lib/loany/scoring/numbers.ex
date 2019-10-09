defmodule Loany.Scoring.Numbers do
  @moduledoc """
  Module for work with numbers.
  """

  @doc """
  Checks if a number is a prime number.
  """
  def is_prime?(2), do: true

  def is_prime?(num) do
    last =
      num
      |> :math.sqrt()
      |> Float.ceil()
      |> trunc

    notprime =
      2..last
      |> Enum.any?(fn a -> rem(num, a) == 0 end)

    !notprime
  end
end
