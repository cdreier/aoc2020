list =
  File.read!("input.txt")
  |> String.trim()
  |> String.split("\n\n")
  |> Stream.map(&String.graphemes(&1))
  |> Stream.map(&Enum.frequencies(&1))
  |> Enum.to_list()

expectedAnswers = fn i ->
  case i do
    %{"\n" => count} -> count + 1
    _ -> 1
  end
end

list =
  list
  |> Stream.map(fn i ->
    answerCount = expectedAnswers.(i)

    debug =
      Enum.filter(i, fn j ->
        {_, c} = j
        c == answerCount
      end)

    debug
  end)
  |> Enum.to_list()

res =
  Enum.reduce(list, 0, fn i, acc ->
    Enum.count(i) + acc
  end)

IO.inspect(res)
