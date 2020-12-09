defmodule Day9 do
  def run(file, preambleSize) do
    list =
      File.read!(file)
      |> String.split("\n", trim: true)
      |> Stream.map(&String.to_integer/1)
      |> Enum.to_list()

    [{part1result, _}] = part1(list, preambleSize)
    IO.puts("part 1: #{part1result}")

    # part 2
    [{res, _}] = findWeakness(list, 2, part1result)

    res = Enum.sort(res)
    res = List.last(res) + List.first(res)
    IO.puts("part 2 #{res}")
  end

  def preambles(list, size) do
    list |> Stream.chunk_every(size, 1) |> Enum.to_list()
  end

  def findWeakness(list, preambleSize, target) do
    preambles = preambles(list, preambleSize)

    check =
      preambles
      |> Stream.map(fn preamble ->
        {preamble, Enum.reduce(preamble, fn i, acc -> acc + i end)}
      end)
      |> Stream.filter(fn {_, test} -> test == target end)
      |> Enum.take(1)

    unless Enum.count(check) > 0 do
      findWeakness(list, preambleSize + 1, target)
    else
      check
    end
  end

  def part1(list, preambleSize) do
    preambles = preambles(list, preambleSize)

    Stream.with_index(list)
    |> Stream.drop(preambleSize)
    |> Stream.drop_while(fn i ->
      {val, index} = i
      checkSum(Enum.at(preambles, index - preambleSize), val)
    end)
    |> Enum.take(1)
  end

  def checkSum(preamble, n) do
    check =
      preamble
      |> Stream.filter(fn i -> Enum.member?(preamble, n - i) end)
      |> Enum.count()

    check > 0
  end
end

Day9.run("input.txt", 25)
