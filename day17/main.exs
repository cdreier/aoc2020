defmodule Day17 do
  def run(file) do
    list =
      File.read!(file)
      |> String.split("\n", trim: true)
      |> Stream.map(&String.graphemes/1)
      |> Enum.to_list()

    data = toMap(list)

    # out(data, -1)
    # out(data, 0)
    # out(data, 1)

    res = part1(data)

    IO.inspect(res)

    # out(Enum.at(res, 1), -1)
    # out(Enum.at(res, 1), 0)
    # out(Enum.at(res, 1), 1)
    # out(List.last(res), 0)
  end

  def out(map, z) do
    IO.puts("z=#{z}")
    IO.puts("#{map[{-1, 0, z}]}#{map[{0, 0, z}]}#{map[{1, 0, z}]}#{map[{2, 0, z}]}")
    IO.puts("#{map[{-1, 1, z}]}#{map[{0, 1, z}]}#{map[{1, 1, z}]}#{map[{2, 1, z}]}")
    IO.puts("#{map[{-1, 2, z}]}#{map[{0, 2, z}]}#{map[{1, 2, z}]}#{map[{2, 2, z}]}")
    IO.puts("#{map[{-1, 3, z}]}#{map[{0, 3, z}]}#{map[{1, 3, z}]}#{map[{2, 3, z}]}")
  end

  def toMap(list) do
    rows = Enum.count(list)

    for y <- 0..(rows - 1),
        x <- 0..(rows - 1),
        z <- -1..1,
        into: %{},
        do: fillPlane(list, x, y, z)
  end

  def fillPlane(list, x, y, 0), do: {{x, y, 0}, Enum.at(Enum.at(list, y, []), x, ".")}
  def fillPlane(_list, x, y, -1), do: {{x, y, -1}, "."}
  def fillPlane(_list, x, y, 1), do: {{x, y, 1}, "."}

  def part1(data) do
    res =
      Stream.unfold({data, 0}, fn {m, count} ->
        if count == 7 do
          nil
        else
          n = process(m)

          IO.puts("run #{count}")

          {{m, count}, {n, count + 1}}
        end
      end)
      |> Stream.map(fn {m, _count} -> m end)
      |> Enum.to_list()

    # IO.inspect(res)
    # IO.inspect(Enum.count(res))

    List.last(res)
    |> Stream.map(fn {_i, val} -> val end)
    |> Enum.frequencies()
  end

  def process(data) do
    # IO.inspect(Enum.count(data))
    # IO.inspect(data)

    # data =
    #   Enum.reduce(data, data, fn {coord, _val}, acc ->
    #     coordinatesAround(coord)
    #     |> Enum.flat_map(fn nc ->
    #       Map.put_new(acc, nc, ".")
    #     end)
    #     |> Enum.into(%{})
    #   end)

    # IO.inspect(Enum.count(data))

    Enum.map(data, fn {coord, val} ->
      map =
        coordinatesAround(coord)
        |> Enum.map(fn c ->
          Map.put_new(data, c, ".")
        end)
        |> Enum.into(%{})

      o = activeCubes(map, coord)
      {coord, processCube(val, o)}
    end)
    |> Enum.into(%{})
  end

  def activeCubes(data, {x, y, z}) do
    active =
      coordinatesAround({x, y, z})
      |> Stream.map(fn c ->
        Map.get(data, c, ".")
      end)
      |> Enum.frequencies()

    # if x == 0 && y == 1 && z == 0 do
    #   IO.inspect(active)
    # end

    Map.get(active, "#", 0)
  end

  def processCube("#", 2), do: "#"
  def processCube("#", 3), do: "#"
  def processCube(".", 3), do: "#"
  def processCube("#", _occupied), do: "."
  def processCube(".", _occupied), do: "."

  def coordinatesAround({x, y, z}) do
    [
      {x - 1, y - 1, z - 1},
      {x, y - 1, z - 1},
      {x + 1, y - 1, z - 1},
      {x - 1, y, z - 1},
      {x + 1, y, z - 1},
      {x - 1, y + 1, z - 1},
      {x, y + 1, z - 1},
      {x + 1, y + 1, z - 1},
      {x - 1, y - 1, z},
      {x, y - 1, z},
      {x + 1, y - 1, z},
      {x - 1, y, z},
      {x + 1, y, z},
      {x - 1, y + 1, z},
      {x, y + 1, z},
      {x + 1, y + 1, z},
      {x - 1, y - 1, z + 1},
      {x, y - 1, z + 1},
      {x + 1, y - 1, z + 1},
      {x - 1, y, z + 1},
      {x + 1, y, z + 1},
      {x - 1, y + 1, z + 1},
      {x, y + 1, z + 1},
      {x + 1, y + 1, z + 1}
    ]
  end
end

Day17.run("test.txt")
