defmodule Day13 do
  def run(file) do
    [target, busses] =
      File.read!(file)
      |> String.split("\n", trim: true)
      |> Enum.to_list()

    busses =
      String.split(busses, ",")
      |> Stream.filter(&(&1 != "x"))
      |> Stream.map(&String.to_integer/1)
      |> Enum.to_list()

    IO.inspect(busses)
    target = String.to_integer(target)

    times =
      busses
      |> Stream.map(&checkTime(&1, 0, target))
      |> Enum.to_list()
      |> IO.inspect()

    {busID, time} = Enum.min_by(times, fn {_, i} -> i end)
    wait = time - target
    IO.inspect(busID * wait)
  end

  def checkTime(i, acc, target) when acc >= target, do: {i, acc}
  def checkTime(i, acc, target), do: checkTime(i, acc + i, target)
end

Day13.run("input.txt")
