res =
  File.read!("input.txt")
  |> String.split("\n\n")
  |> Stream.map(&String.replace(&1, "\n", " "))
  |> Stream.map(&String.replace(&1, "cid:", ""))
  |> Stream.filter(&(Enum.count(String.graphemes(&1), fn i -> i == ":" end) >= 7))
  |> Enum.count()

IO.inspect(res)
