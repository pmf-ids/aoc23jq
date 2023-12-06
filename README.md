# Solving [Advent of Code](https://adventofcode.com/) [2023](https://adventofcode.com/2023/) in [jq](https://jqlang.github.io/jq/) [1.7](https://github.com/jqlang/jq/releases/tag/jq-1.7)

The solutions presented here are written in
jq 1.7, which was released on September 7, 2023. They require
invoking `jq` with some flags (mostly `-R` and `-n`), which are
specified in the example invocations preceding each code section
below, using `solve.jq` and `input.txt` as filenames for the
source code and the input data, respectively. The actual source
code files in this repository, however, also contain a corresponding
shebang prefix, so running them with just `./solve.jq input.txt`
(and execution permissions set) should equally be possible on
most Unix-like operating systems.

## [🖿 01](01) solving [Day 1: Trebuchet?!](https://adventofcode.com/2023/day/1)
`jq -Rnf solve.jq input.txt`
```jq
[inputs / ""] | ., map(reduce (
  [[], indices(("one two three four five six seven eight nine" / " ")[] / "")]
  | to_entries[] | .value = .value[] + 1
) as $e (.; .[$e.value] = $e.key)) | map(map(tonumber?) | first * 10 + last)? | add
```

## [🖿 02](02) solving [Day 2: Cube Conundrum](https://adventofcode.com/2023/day/2)
`jq -Rnf solve.jq input.txt`
```jq
[inputs | [scan("\\w+") | tonumber? // ["red","green","blue"][[.]][0] + 13] | [_nwise(2)]]
| map(select(.[1:] | all(first < last))[0][1] // 0),
  map(reduce(.[1:] | group_by(last)[] | max_by(first)[0]) as $p (1; . * $p))
| add
```

## [🖿 03](03) solving [Day 3: Gear Ratios](https://adventofcode.com/2023/day/3)
`jq -Rnf solve.jq input.txt`
```jq
["", inputs, ""] | [("\\d+","[^\\d.]") as $r | [to_entries[] | .value |= [match($r;"g")]]]
| reduce (first[] | {key} + .value[] | .string |= tonumber) as $n (last; (
    .[$n.key + (-1,0,1)].value[] | select([-1, .offset - $n.offset, $n.length] | . == sort)
  ).nums += [$n]) | [.[].value[] | [[.nums[].string],
    [select(.string == "*").nums | select(length == 2) | first.string * last.string]
  ]] | transpose[] | add | add
```

## [🖿 04](04) solving [Day 4: Scratchcards](https://adventofcode.com/2023/day/4)
`jq -Rnf solve.jq input.txt`
```jq
[inputs / ":" | last / "|" | map([scan("\\d+")]) | first - (first - last) | length]
| [map(select(. > 0) - 1 | exp2)],
  reduce range(length) as $i ([., map(1)]; last[$i + range(first[$i]) + 1] += last[$i])
| last | add
```

## [🖿 05](05) solving [Day 5: If You Give A Seed A Fertilizer](https://adventofcode.com/2023/day/5)
`jq -Rnf solve.jq input.txt`
```jq
[inputs] | [(join(",") / ",,")[] / "," | map([scan("\\d+") | tonumber])]
| [(.[0][0] | map([.,1]), [_nwise(2)]), .[1:][] | map((.[-1] += .[-2])?)]
| .[:2][] as $seed | .[2:] | map(map(.[0] -= .[1]))

| reduce .[] as $map ($seed; reduce $map[] as $r ([.,[]]; reduce first[] as $q (first = [];
    if ($q[0] - $r[2]) * ($q[1] - $r[1]) > 0 then first += [$q] else
      ($q + $r[1:] | sort) as $seg | last += [[$seg[1,2] + $r[0]]]
      | first += [[$q[0], $seg[1]], [$seg[2], $q[1]] | select(first < last)]
    end
  )) | add) | map(first) | min
```

## [🖿 06](06) solving [Day 6: Wait For It](https://adventofcode.com/2023/day/6)
`jq -Rnf solve.jq input.txt`
```jq
[inputs | [scan("\\d+")] | [., [add] | map(tonumber)]] | transpose[] | transpose
| reduce .[] as [$t,$d] (1; . * ($t * $t / 4 - $d | sqrt | round * 2 + $t % 2 - 1))
```
