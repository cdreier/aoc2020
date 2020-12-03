list =
  File.read!("input.txt")
  |> String.trim()
  |> String.split("\n")
  |> Enum.to_list()

stepsToBottom = Enum.count(list)

rowlen = String.length(Enum.at(list, 0))

gen = fn x, y ->
  for row <- 0..(stepsToBottom - 1), do: {row * x, row * y}
end

calc = fn coords ->
  trees =
    Enum.map(coords, fn c ->
      {x, y} = c
      row = Enum.at(list, y)

      unless row == nil do
        fullrow = String.duplicate(row, round(x / rowlen) + 1)

        String.at(fullrow, x)
      end
    end)

  Enum.frequencies(trees)
end

res =
  [gen.(1, 1), gen.(3, 1), gen.(5, 1), gen.(7, 1), gen.(1, 2)]
  |> Stream.map(fn item -> calc.(item) end)
  |> Stream.map(fn item ->
    {:ok, n} = Map.fetch(item, "#")
    n
  end)
  |> Enum.reduce(fn i, acc -> acc * i end)

IO.inspect(res)
