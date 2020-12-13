defmodule Day13 do
  def run(file) do
    list =
      File.read!(file)
      |> String.split("\n", trim: true)
      |> Stream.map(&String.graphemes/1)
      |> Enum.to_list()
  end
end

Day11.run("test.txt")
