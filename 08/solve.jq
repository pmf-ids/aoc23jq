#!/usr/bin/env -S jq -Rnf

# AoC 2023/08 in jq 1.7

[inputs] | [first | explode[] % 5] as $nav | INDEX(.[2:][] | [scan("\\w+")]; first) as $map
| (["AAA","ZZZ"],["A$","Z$"]) as [$a,$z] | $map | reduce (.[][0] | select(test($a)) | [.,0]
    | until(first | test($z); [$map[first][$nav[(last) % ($nav | length)]], last + 1])[1]
  ) as $n (1; . * $n / ([., $n] | until(last == 0; [last, first % last]) | first)) # lcm
