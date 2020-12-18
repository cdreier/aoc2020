
defmodule Day18 do

  @part1 """
  defmodule MyOperators do
    def a >>> b, do: a + b
    def a <<< b, do: a * b
  end
  """

  @part2 """
  defmodule MyOperators do
    def a ^^^ b, do: a + b
    def a <<< b, do: a * b
  end
  """

  def run(file) do

    Code.eval_string(@part2)

    File.read!(file)
    |> String.split("\n", trim: true)
    |> Stream.map(&String.replace(&1, "+", "^^^"))
    |> Stream.map(&String.replace(&1, "*", "<<<"))
    |> Stream.map(&eval/1)
    |> Stream.map(fn {x, _} -> x end)
    |> Enum.sum()
    |> IO.puts()
  end

  def eval(line) do
    Code.eval_string(~s"""
    import MyOperators
    #{line}
    """)
  end

end

Day18.run("input.txt")
