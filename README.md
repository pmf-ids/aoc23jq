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

## [🖿 07](07) solving [Day 7: Camel Cards](https://adventofcode.com/2023/day/7)
`jq -Rnf solve.jq input.txt`
```jq
[inputs/" "] | ("\(1,"J")23456789TJQKA"/"") as $cr | map(first |= (./"" | map($cr[[.]][0])
  | (group_by(. > 0) | map(group_by(.) | map(-length) | sort) | transpose | map(-add)) + .
)) | sort | to_entries | map((.key + 1) * (.value | last | tonumber)) | add
```

## [🖿 08](08) solving [Day 8: Haunted Wasteland](https://adventofcode.com/2023/day/8)
`jq -Rnf solve.jq input.txt`
```jq
[inputs] | [first | explode[] % 5] as $nav | INDEX(.[2:][] | [scan("\\w+")]; first) as $map
| (["AAA","ZZZ"],["A$","Z$"]) as [$a,$z] | $map | reduce (.[][0] | select(test($a)) | [.,0]
    | until(first | test($z); [$map[first][$nav[(last) % ($nav | length)]], last + 1])[1]
  ) as $n (1; . * $n / ([., $n] | until(last == 0; [last, first % last]) | first)) # lcm
```

## [🖿 09](09) solving [Day 9: Mirage Maintenance](https://adventofcode.com/2023/day/9)
`jq -Rnf solve.jq input.txt`
```jq
[inputs / " "| map(tonumber)] | ., map(reverse)
| map([while(any(. != 0); [.[range(length - 1):] | .[1] - .[0]]) | last] | add) | add
```

## [🖿 11](11) solving [Day 11: Cosmic Expansion](https://adventofcode.com/2023/day/11)
`jq -Rnf solve.jq input.txt`
```jq
[inputs / ""] | [[transpose, .] | [map(map(min == max)[[true]]), reverse] | transpose[]
  | (reduce first[] as $d ([last[] | 0]; .[$d:][] += 1)) as $ds | [last[] | indices("#")[]]
  | combinations(2) | select(first < last) | [last - first, $ds[last] - $ds[first]]
] | transpose | map(add) | first + last * (1, 999999)
```

## [🖿 13](13) solving [Day 13: Point of Incidence](https://adventofcode.com/2023/day/13)
`jq -Rnf solve.jq input.txt`
```jq
[inputs] | (0,11) as $d | [(join(",") / ",,")[] / "," | map(explode) | [., transpose | [
  range(1; length) as $w | [(reverse[-$w:], .[$w:])[:[$w, length - $w] | min] | add]
  | transpose | map(first - last | fabs) | add
] | (index($d) // -1) + 1] | 100 * first + last] | add
```

## [🖿 14](14) solving [Day 14: Parabolic Reflector Dish](https://adventofcode.com/2023/day/14)
`jq -Rnf solve.jq input.txt`
```jq
def rotate: map(. / "") | transpose | map(reverse | add); # clockwise
def tilt: rotate | map(. / "#" | map(. / "" | sort | add) | join("#")); # rightward
def load: rotate | to_entries | map((.key + 1) * (.value | indices("O") | length)) | add;

[inputs] | tilt, (1000000000 as $cycles | [0, {}, .] | until(first == $cycles;
  [nth(4; last | recurse(tilt)) | ., add] as [$dish, $key] | .[1][$key] as $loop
  | last = $dish | .[1][$key] //= first
  | first |= if $loop and ($cycles - .) % (. - $loop) == 1 then $cycles else . + 1 end
) | last | rotate) | load
```

## [🖿 15](15) solving [Day 15: Lens Library](https://adventofcode.com/2023/day/15)
`jq -Rf solve.jq input.txt`
```jq
def hash: reduce explode[] as $c (0; (. + $c) * 17 % 256);

. / "," | map(hash), (
  reduce (.[] | [splits("-|=")] | last |= tonumber?) as [$label, $num] ([];
    .[$label | hash] |= if $num then .[$label] = $num else delpaths([[$label]]) end
  ) | to_entries | map(
    (.key + 1) * (.value | to_entries? | to_entries[] | (.key + 1) * .value.value)
  )
) | add
```

## [🖿 18](18) solving [Day 18: Lavaduct Lagoon](https://adventofcode.com/2023/day/18)
`jq -Rnf solve.jq input.txt`
```jq
[inputs | [scan("\\w+")]
  | .[0] |= explode[] % 35 % 4
  | .[2:3] |= map(.[-1:], .[:-1])
  | .[3] |= ([explode[] % 39 - 9] | [to_entries[] | (16 - 4 * .key | exp2) * .value] | add)
  | .[1,2] |= tonumber | [_nwise(2)]
]
| transpose[] | (map(last) | add) as $o
| reduce .[] as [$d,$n] ([[0,0]]; . + [last | .[$d % 2] += $n * copysign(1; 1 - $d)])
| [., reverse | flatten[1:-1] | [_nwise(2) | first * last] | add / 2]
| max - min + $o / 2 + 1
```

## [🖿 20](20) solving [Day 20: Pulse Propagation](https://adventofcode.com/2023/day/20)
`jq -Rnf solve.jq input.txt`
```jq
[inputs | [scan("(%|&)?(\\w+)")] | {id:.[0][1], type:.[0][0], to:[.[1:][][1]]}]
| reduce (.[] | .to = .to[]) as {$id, $to} (INDEX(.id); .[$to].from[$id] = false)
| reduce (.rx.from | keys[]) as $rx (.; .rx.from[$rx] = .[$rx].from)? // . | {mods: .}

| until(all((.mods.rx.from[][])?, .btn >= 1000; .); .mods.broadcaster as {$to}
    | .btn += 1 | .false += ($to | length + 1) | .q += [{to: $to[]}]
    | until(.q == []; .q as [{$id, $to, $ps}] | .q |= .[1:] | ."\($ps)" += 1
        | if $to == "rx" then (.mods | (.rx.from | keys[]) as $rx
            | .rx.from[$rx][.[$rx].from | keys[] as $id | select(.[$id]) | $id]) //= .btn
          elif .mods[$to].type == "&" then .mods[$to].from[$id] = $ps
            | .q += [.mods[$to] | {id: $to, to: .to[], ps: any(.from[]; not)}?]
          else select($ps) // (.mods[$to].ps |= not
            | .q += [.mods[$to] | {id: $to, to: .to[], ps}?])
          end
      )
    | if .btn == 1000 then .warmup = .true * .false end
  )

| .warmup, reduce .mods.rx.from[][] as $n (1;
    . * $n / ([., $n] | until(last == 0; [last, first % last]) | first) # lcm
  )?
```
