#!/usr/bin/env -S jq -Rnf

# AoC 2023/01 in jq 1.7

[inputs / ""] | ., map(reduce (
  [[], indices(("one two three four five six seven eight nine" / " ")[] / "")]
  | to_entries[] | .value = .value[] + 1
) as $e (.; .[$e.value] = $e.key)) | map(map(tonumber?) | first * 10 + last)? | add
