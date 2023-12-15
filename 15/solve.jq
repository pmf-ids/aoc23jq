#!/usr/bin/env -S jq -Rf

# AoC 2023/15 in jq 1.7

def hash: reduce explode[] as $c (0; (. + $c) * 17 % 256);

. / "," | map(hash), (
  reduce (.[] | [splits("-|=")] | last |= tonumber?) as [$label, $num] ([];
    .[$label | hash] |= if $num then .[$label] = $num else delpaths([[$label]]) end
  ) | to_entries | map(
    (.key + 1) * (.value | to_entries? | to_entries[] | (.key + 1) * .value.value)
  )
) | add
