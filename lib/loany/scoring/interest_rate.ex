defmodule Loany.Scoring.InterestRate do
  @moduledoc """
  Interes rate algorithm.
  """

  alias Decimal, as: D

  @min_rate 4
  @max_rate 12

  @doc """
  Generates a random float value between @min_rate and @max_rate
  based on generated seed.
  """
  def generate do
    <<i1::unsigned-integer-32, i2::unsigned-integer-32, i3::unsigned-integer-32>> =
      :crypto.strong_rand_bytes(12)

    :rand.seed(:exsplus, {i1, i2, i3})

    random_float = Float.round(:rand.uniform() * 10, 2)
    random_int = trunc(random_float)

    random_float
    |> D.from_float()
    |> D.sub(random_int)
    |> D.add(@min_rate + rem(random_int, @max_rate - @min_rate))
    |> D.to_float()
  end
end
