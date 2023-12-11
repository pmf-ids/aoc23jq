#!/usr/bin/env -S jq -Rnf

# AoC 2023/11 in jq 1.7

[inputs / ""] | [[transpose, .] | [map(map(min == max)[[true]]), reverse] | transpose[]
  | (reduce first[] as $d ([last[] | 0]; .[$d:][] += 1)) as $ds | [last[] | indices("#")[]]
  | combinations(2) | select(first < last) | [last - first, $ds[last] - $ds[first]]
] | transpose | map(add) | first + last * (1, 999999)
