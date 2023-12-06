#!/usr/bin/env -S jq -Rnf

# AoC 2023/06 in jq 1.7

[inputs | [scan("\\d+")] | [., [add] | map(tonumber)]] | transpose[] | transpose
| reduce .[] as [$t,$d] (1; . * ($t * $t / 4 - $d | sqrt | round * 2 + $t % 2 - 1))
