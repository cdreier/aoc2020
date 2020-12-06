list =
  File.read!("input.txt")
  |> String.split("\n\n")
  |> Stream.map(&String.replace(&1, "\n", ""))
  |> Stream.map(&String.graphemes(&1))
  |> Stream.map(&Enum.frequencies(&1))
  |> Enum.to_list()

res =
  Enum.reduce(list, 0, fn i, acc ->
    Enum.count(i) + acc
  end)

IO.inspect(res)
