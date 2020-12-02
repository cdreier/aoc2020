defmodule PWCheck do
  defstruct min: 0, max: 0, letter: '', pw: "asdf"

  def check(a) do
    freq = Enum.frequencies(String.to_charlist(a.pw))
    a.min <= freq[a.letter] and freq[a.letter] <= a.max
  end

  def checkToboggan(a) do
    list = String.to_charlist(a.pw)
    checkMax = Enum.at(list, a.max - 1) == a.letter
    checkMin = Enum.at(list, a.min - 1) == a.letter

    (checkMin && !checkMax) || (!checkMin && checkMax)
  end
end

defmodule Main do
  def main do
    list =
      File.read!("input.txt")
      |> String.trim()
      |> String.split("\n")
      |> Stream.map(fn l ->
        [rules, pw] = String.split(l, ": ")
        [occurences, letter] = String.split(rules, " ")
        [min, max] = String.split(occurences, "-")

        %PWCheck{
          min: String.to_integer(min),
          max: String.to_integer(max),
          letter: Enum.at(String.to_charlist(letter), 0),
          pw: pw
        }
      end)
      # |> Stream.filter(&PWCheck.check/1)
      |> Stream.filter(&PWCheck.checkToboggan/1)
      |> Enum.to_list()

    IO.inspect(Enum.count(list))
  end
end

Main.main()
