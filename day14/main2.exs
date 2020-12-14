defmodule Day14 do
  def run(file) do
    res =
      File.read!(file)
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{"mask" => ""}, fn i, acc ->
        [cmd, val] = String.split(i, " = ")
        [cmd, val] = run(cmd, val, acc["mask"])
        Map.update(acc, cmd, val, fn _i -> val end)
      end)

    Map.drop(res, ["mask"])
    |> Map.keys()
    |> Stream.map(&res[&1])
    |> Stream.flat_map(&expand/1)
    |> Stream.map(&todec/1)
    |> Enum.reduce(fn i, acc -> i + acc end)
    |> IO.inspect()
  end

  def expand(i) do
    c = String.graphemes(i) |> Enum.frequencies()
    c = :math.pow(2, c["X"])
  end

  def run("mask", val, _m), do: ["mask", val]

  def run(cmd, val, mask) do
    bin = tobin(String.to_integer(val))

    val =
      Stream.with_index(String.graphemes(bin))
      |> Enum.map(fn {_i, index} -> String.at(mask, index) end)
      |> Enum.join("")

    [cmd, val]
  end

  def tobin(i), do: String.pad_leading("#{Integer.to_string(i, 2)}", 36, "0")

  def todec(i), do: String.to_integer(i, 2)
end

Day14.run("test2.txt")
# Day14.run("input.txt")
