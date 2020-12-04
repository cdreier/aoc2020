checkNumberRange = fn number, min, max ->
  n = String.to_integer(number)

  n >= min && n <= max
end

File.read!("input.txt")
|> String.split("\n\n")
|> Stream.map(&String.replace(&1, "\n", " "))
|> Stream.map(&String.replace(&1, "cid:", ""))
|> Stream.map(fn i ->
  String.split(i, " ")
  |> Stream.filter(&String.contains?(&1, ":"))
  |> Enum.to_list()
end)
|> Stream.filter(&(Enum.count(&1) >= 7))
|> Stream.filter(fn attrs ->
  validCount =
    attrs
    |> Stream.filter(fn a ->
      pair = String.split(a, ":")

      case pair do
        ["byr", byr] ->
          checkNumberRange.(byr, 1920, 2002)

        ["ecl", ecl] ->
          Enum.member?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], ecl)

        ["eyr", eyr] ->
          checkNumberRange.(eyr, 2020, 2030)

        ["hgt", hgt] ->
          cond do
            String.contains?(hgt, "cm") ->
              n = String.replace(hgt, "cm", "")

              checkNumberRange.(n, 150, 193)

            String.contains?(hgt, "in") ->
              n = String.replace(hgt, "in", "")

              checkNumberRange.(n, 59, 76)

            true ->
              false
          end

        ["hcl", hcl] ->
          String.match?(hcl, ~r/\A#[a-f0-9]{6}\z/)

        ["iyr", iyr] ->
          checkNumberRange.(iyr, 2010, 2020)

        ["pid", pid] ->
          String.match?(pid, ~r/\A\d{9}\z/)
      end
    end)
    |> Enum.count()

  validCount == 7
end)
|> Enum.count()
|> IO.inspect()
