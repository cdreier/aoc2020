defmodule Day11 do
  def run(file) do
    list =
      File.read!(file)
      |> String.split("\n", trim: true)
      |> Stream.map(&String.graphemes/1)
      |> Enum.to_list()

    # part1(list) |> IO.inspect()
    part2(list) |> IO.inspect()
  end

  def part2(list) do
    res = toMap(list)

    res =
      Stream.unfold({res, false}, fn {m, done} ->
        if done do
          nil
        else
          n = process2(m)

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
  end

  def process2(data) do
    directions = coordinatesAround({0, 0})

    Enum.map(data, fn {{x, y}, val} ->
      o = occupiedSeats(data, {x, y}, directions)
      {{x, y}, processSeat(val, o, 5)}
    end)
    |> Enum.into(%{})
  end

  def toMap(list) do
    rows = Enum.count(list)
    seats = Enum.count(Enum.at(list, 0))

    for y <- 0..(rows - 1),
        x <- 0..(seats - 1),
        into: %{},
        do: {{x, y}, Enum.at(Enum.at(list, y), x)}
  end

  def part1(list) do
    res = toMap(list)

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
  end

  def process(data) do
    Enum.map(data, fn {{x, y}, val} ->
      o = occupiedSeats(data, {x, y})
      {{x, y}, processSeat(val, o, 4)}
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

  def checkSeat("L", _map, _coord, _dir), do: 0
  def checkSeat("#", _map, _coord, _dir), do: 1

  def checkSeat(_i, map, {x, y}, {dx, dy}),
    do: checkSeat(Map.get(map, {x + dx, y + dy}, "L"), map, {x + dx, y + dy}, {dx, dy})

  def occupiedSeats(data, {x, y}, directions) do
    directions
    |> Stream.map(fn {dx, dy} ->
      checkSeat(Map.get(data, {x + dx, y + dy}, "L"), data, {x + dx, y + dy}, {dx, dy})
    end)
    |> Enum.reduce(fn i, acc -> i + acc end)
  end

  def processSeat("L", 0, _c), do: "#"
  def processSeat("#", occupied, c) when occupied >= c, do: "L"
  def processSeat(i, _occupied, _c), do: i

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
