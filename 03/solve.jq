#!/usr/bin/env -S jq -Rnf

# AoC 2023/03 in jq 1.7

["", inputs, ""] | [("\\d+","[^\\d.]") as $r | [to_entries[] | .value |= [match($r;"g")]]]
| reduce (first[] | {key} + .value[] | .string |= tonumber) as $n (last; (
    .[$n.key + (-1,0,1)].value[] | select([-1, .offset - $n.offset, $n.length] | . == sort)
  ).nums += [$n]) | [.[].value[] | [[.nums[].string],
    [select(.string == "*").nums | select(length == 2) | first.string * last.string]
  ]] | transpose[] | add | add
