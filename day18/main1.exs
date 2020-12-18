defmodule Day18 do
  def run(file) do
    res =
      File.read!(file)
      |> String.split("\n", trim: true)
      |> Stream.map(&line/1)
      |> Stream.map(&calc/1)
      |> Enum.sum()

    IO.inspect(res)
  end

  def calc(all), do: calc(all, nil, 0)
  def calc([], nil, acc), do: acc
  def calc(["*" | rest], nil, acc), do: calc(rest, "*", acc)
  def calc(["+" | rest], nil, acc), do: calc(rest, "+", acc)
  def calc(["(" | rest], op, acc), do: calc(rest) |> calc(op, acc)
  def calc([")" | rest], nil, acc), do: [acc | rest]
  def calc([num | rest], "*", acc), do: calc(rest, nil, acc * num)
  def calc([num | rest], "+", acc), do: calc(rest, nil, acc + num)
  def calc([num | rest], nil, 0), do: calc(rest, nil, num)

  def line(l) do
    l
    |> String.graphemes()
    |> Stream.filter(&(&1 != " "))
    |> Stream.map(&parseChar/1)
    |> Enum.to_list()
  end

  def parseChar(c) when c in ["(", ")", "+", "*"], do: c
  def parseChar(c), do: String.to_integer(c)
end

Day18.run("input.txt")
