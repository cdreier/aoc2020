defmodule Day7 do
  def createBags(line) do
    [self, tmp] = String.split(line, "contain")
    self = String.trim(self)

    unless String.contains?(tmp, "no other") do
      children =
        String.split(tmp, ", ")
        |> Stream.map(&String.trim/1)
        |> Stream.map(fn i ->
          {count, color} = String.split_at(i, 1)
          %{"color" => String.trim(color), "count" => String.to_integer(count)}
        end)
        |> Enum.to_list()

      %{"color" => self, "children" => children}
    else
      %{"color" => self, "children" => []}
    end
  end

  def containsColor(all, colors, break) do
    matched =
      all
      |> Stream.filter(fn i ->
        check = for a <- i["children"], b <- colors, String.contains?(a["color"], b), do: true
        Enum.count(check) > 0
      end)
      |> Enum.to_list()

    matchedColors = Enum.map(matched, & &1["color"])

    IO.puts(" #{Enum.count(matchedColors)} ")

    if Enum.count(matchedColors) == break do
      matchedColors
    else
      containsColor(all, colors ++ matchedColors, Enum.count(matchedColors))
    end
  end

  def part2(all, color) do
    Enum.reduce(all[color], 0, fn i, acc ->
      count = i["count"]
      acc + count + count * part2(all, i["color"])
    end)
  end
end

# File.read!("test.txt")
bagList =
  File.read!("input.txt")
  |> String.trim()
  |> String.split("\n")
  |> Stream.map(&String.replace(&1, "bags", ""))
  |> Stream.map(&String.replace(&1, "bag", ""))
  |> Stream.map(&String.replace(&1, ".", ""))
  |> Stream.map(&Day7.createBags(&1))
  |> Enum.to_list()

bagMap =
  Enum.reduce(bagList, %{}, fn i, acc ->
    Map.put(acc, i["color"], i["children"])
  end)

res = Day7.part2(bagMap, "shiny gold")

IO.inspect(res)
