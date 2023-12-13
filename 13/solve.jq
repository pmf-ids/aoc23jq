#!/usr/bin/env -S jq -Rnf

# AoC 2023/13 in jq 1.7

[inputs] | (0,11) as $d | [(join(",") / ",,")[] / "," | map(explode) | [., transpose | [
  range(1; length) as $w | [(reverse[-$w:], .[$w:])[:[$w, length - $w] | min] | add]
  | transpose | map(first - last | fabs) | add
] | (index($d) // -1) + 1] | 100 * first + last] | add
