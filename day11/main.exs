defmodule Day11 do
  def run(file) do
    list =
      File.read!(file)
      |> String.split("\n", trim: true)
      |> Stream.map(&String.graphemes/1)
      |> Enum.to_list()

    _res = part1(list)
  end

  def part1(list) do
    rows = Enum.count(list)
    seats = Enum.count(Enum.at(list, 0))

    res =
      for y <- 0..(rows - 1),
          x <- 0..(seats - 1),
          into: %{},
          do: {{x, y}, Enum.at(Enum.at(list, y), x)}

    res =
      Stream.unfold({res, false}, fn {m, done} ->

        if done do
          nil
        else
          n = process(m)

          if Map.equal?(m, n) do
            {{m, done}, {n, true}}
          else
            {{m, done}, {n, false}}
          end
        end
      end)
      |> Stream.map(fn {m, _done} -> m end)
      |> Enum.to_list()

    List.last(res)
    |> Stream.map(fn {_i, val} -> val end)
    |> Enum.frequencies()
    |> IO.inspect()
  end

  def process(data) do
    Enum.map(data, fn {{x, y}, val} ->
      o = occupiedSeats(data, {x, y})
      {{x, y}, processSeat(val, o)}
    end)
    |> Enum.into(%{})
  end

  def occupiedSeats(data, {x, y}) do
    seats =
      coordinatesAround({x, y})
      |> Stream.map(&Map.get(data, &1, "."))
      |> Enum.frequencies()

    Map.get(seats, "#", 0)
  end

  def processSeat("L", 0), do: "#"
  def processSeat("#", occupied) when occupied >= 4, do: "L"
  def processSeat(i, _occupied), do: i

  def coordinatesAround({x, y}) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
  end
end

Day11.run("input.txt")
