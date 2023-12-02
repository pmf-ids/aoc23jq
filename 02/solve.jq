#!/usr/bin/env -S jq -Rnf

# AoC 2023/02 in jq 1.7

[inputs | [scan("\\w+") | tonumber? // ["red","green","blue"][[.]][0] + 13] | [_nwise(2)]]
| map(select(.[1:] | all(first < last))[0][1] // 0),
  map(reduce(.[1:] | group_by(last)[] | max_by(first)[0]) as $p (1; . * $p))
| add
