upperHalf = fn c ->
  {min, max} = c
  range = max - min
  newRange = floor(range / 2)
  {max - newRange, max}
end

lowerHalf = fn c ->
  {min, max} = c
  range = max - min
  newRange = floor(range / 2)
  {min, min + newRange}
end

calc = fn i ->
  {rows, seats} = String.split_at(i, 7)

  {row, _} =
    Enum.reduce(String.graphemes(rows), {0, 127}, fn s, acc ->
      case s do
        "F" -> lowerHalf.(acc)
        "B" -> upperHalf.(acc)
      end
    end)

  {seat, _} =
    Enum.reduce(String.graphemes(seats), {0, 7}, fn s, acc ->
      case s do
        "L" -> lowerHalf.(acc)
        "R" -> upperHalf.(acc)
      end
    end)

  row * 8 + seat
end

list =
  File.read!("input.txt")
  |> String.trim()
  |> String.split("\n")
  |> Stream.map(&calc.(&1))
  |> Enum.to_list()

IO.inspect(Enum.max(list))

list = Enum.sort(list)

Enum.reduce(list, fn i, acc ->
  if acc + 2 == i do
    IO.puts("found my seat #{acc + 1}")
  end

  i
end)
