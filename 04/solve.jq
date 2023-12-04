#!/usr/bin/env -S jq -Rnf

# AoC 2023/04 in jq 1.7

[inputs / ":" | last / "|" | map([scan("\\d+")]) | first - (first - last) | length]
| [map(select(. > 0) - 1 | exp2)],
  reduce range(length) as $i ([., map(1)]; last[$i + range(first[$i]) + 1] += last[$i])
| last | add
