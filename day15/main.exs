defmodule Day15 do
  def run(start, stop) do
    init =
      Stream.with_index(start)
      |> Enum.reduce(%{}, fn {e, index}, acc ->
        Map.put(acc, e, [index + 1])
      end)

    turn = Enum.count(init)

    res =
      (turn + 1)..stop
      |> Enum.map(& &1)
      |> Stream.scan(%{"last" => List.last(start), "state" => init}, fn i, acc ->
        n = play(acc["state"], Map.get(acc, "last"))
        acc = Map.update!(acc, "state", fn j -> Map.update(j, n, [i], fn l -> [i | l] end) end)
        Map.update!(acc, "last", fn _j -> n end)
      end)
      |> Stream.drop(stop - turn - 1)
      |> Enum.take(1)
      |> List.first()

    IO.inspect(res["last"])
  end

  def play(state, last) do
    numberData = Map.get(state, last, [])
    tmp = Enum.slice(numberData, 0, 2)
    number(tmp)
  end

  def number([i, j]), do: abs(i - j)
  def number([_i]), do: 0
  def number([]), do: 0
end

# Day15.run([9, 3, 1, 0, 8, 4], 30_000_000)
Day15.run([9, 3, 1, 0, 8, 4], 2020)
