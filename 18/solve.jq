#!/usr/bin/env -S jq -Rnf

# AoC 2023/18 in jq 1.7

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
