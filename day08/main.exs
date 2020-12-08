defmodule Day8 do
  def run(file) do
    program =
      File.read!(file)
      |> String.trim()
      |> String.split("\n")
      |> Stream.map(&String.split(&1, " "))
      |> Enum.to_list()

    instructionCount = Enum.count(program)

    result = List.last(execute(program))
    IO.puts("part 1: #{result["acc"]}")

    result2 =
      Stream.iterate(0, &(&1 + 1))
      |> Enum.take(instructionCount)
      |> Stream.map(&mutate(program, &1))
      |> Stream.map(&List.last(execute(&1)))
      |> Stream.map(&Map.update!(&1, "old", fn i -> Enum.count(i) end))
      |> Enum.to_list()

    result2 =
      Enum.sort(result2, fn a, b ->
        a["old"] <= b["old"]
      end)

    result2 = List.last(result2)
    IO.puts("part 2: #{result2["acc"]}")
  end

  def mutate(p, i) do
    [instr, arg] = Enum.at(p, i)

    instr =
      case instr do
        "nop" -> "jmp"
        "jmp" -> "nop"
        _ -> instr
      end

    List.replace_at(p, i, [instr, arg])
  end

  def calc(start, instr) do
    {sign, val} = String.split_at(instr, 1)

    case sign do
      "-" -> start - String.to_integer(val)
      "+" -> start + String.to_integer(val)
      _ -> start
    end
  end

  def execute(p) do
    instructionCount = Enum.count(p)

    Stream.unfold(%{"acc" => 0, "pointer" => 0, "old" => []}, fn acc ->
      if acc["pointer"] >= instructionCount do
        nil
      else
        unless Enum.member?(acc["old"], acc["pointer"]) do
          [instr, arg] = Enum.at(p, acc["pointer"])
          tmp = Map.update!(acc, "old", &(&1 ++ [acc["pointer"]]))

          newAcc =
            case instr do
              "acc" ->
                tmp = Map.update!(tmp, "acc", &calc(&1, arg))
                Map.update!(tmp, "pointer", &calc(&1, "+1"))

              "jmp" ->
                Map.update!(tmp, "pointer", &calc(&1, arg))

              _ ->
                Map.update!(tmp, "pointer", &calc(&1, "+1"))
            end

          {acc, newAcc}
        else
          nil
        end
      end
    end)
    |> Enum.to_list()
  end
end

Day8.run("input.txt")
