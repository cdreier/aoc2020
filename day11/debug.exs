"#.#L.L#.##
#LLL#LL.L#
L.#.L..#..
#L##.##.L#
#.#L.LL.LL
#.#L#L#.##
..L.L.....
#L#L##L#L#
#.LLLLLL.L
#.#L#L#.##"
|> String.split("\n", trim: true)
|> Stream.flat_map(&String.graphemes/1)
|> Enum.frequencies()
|> IO.inspect()
