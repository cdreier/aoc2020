defmodule Day10 do
  def run(file) do
    list =
      File.read!(file)
      |> String.split("\n", trim: true)
      |> Stream.map(&String.to_integer/1)
      |> Enum.to_list()
      |> Enum.sort()

    res = part1(list)
    IO.inspect(res[1] * res[3])

    # part 2
    _res2 = part2(list)
  end

  def part1(list) do
    [0 | list]
    |> Stream.chunk_every(2, 1, [Enum.max(list) + 3])
    |> Stream.map(fn [a, b] -> b - a end)
    |> Enum.frequencies()
  end

  def part2(list) do
    {sequences, _} =
      [0 | list]
      |> Stream.chunk_every(2, 1, [Enum.max(list) + 3])
      |> Stream.map(fn [a, b] -> b - a end)
      |> Enum.reduce({[], 1}, &countSeq/2)

    aaa =
      sequences
      |> Stream.map(fn i ->
        permutationCount(i)
      end)
      |> Enum.reduce(fn i, acc -> i * acc end)

    IO.inspect(aaa)
  end

  def permutationCount(1), do: 1
  def permutationCount(i), do: permutationCount(i - 1) + i - 2

  def countSeq(1, {cache, seq}), do: {cache, seq + 1}
  def countSeq(_i, {cache, seq}), do: {cache ++ [seq], 1}
end

# Day10.run("test.txt")
Day10.run("input.txt")
