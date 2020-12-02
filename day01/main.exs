list =
  File.read!("input.txt")
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)

# one

_firstStar = fn ->
  Enum.flat_map(list, fn e1 ->
    Enum.filter(list, fn e2 -> e1 + e2 == 2020 end)
  end)
end

# two

secondStar = fn ->
  Enum.flat_map(list, fn e1 ->
    Enum.flat_map(list, fn e2 ->
      Enum.filter(list, fn e3 -> e1 + e2 + e3 == 2020 end)
    end)
  end)
end

# result = firstStar.()
result =
  secondStar.()
  |> Enum.sort()
  |> Enum.dedup()

IO.inspect(result)

one = Enum.at(result, 0)
two = Enum.at(result, 1)
three = Enum.at(result, 2)

IO.puts(one * two * three)
