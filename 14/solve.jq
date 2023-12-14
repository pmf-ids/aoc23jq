#!/usr/bin/env -S jq -Rnf

# AoC 2023/14 in jq 1.7

def rotate: map(. / "") | transpose | map(reverse | add); # clockwise
def tilt: rotate | map(. / "#" | map(. / "" | sort | add) | join("#")); # rightward
def load: rotate | to_entries | map((.key + 1) * (.value | indices("O") | length)) | add;

[inputs] | tilt, (1000000000 as $cycles | [0, {}, .] | until(first == $cycles;
  [nth(4; last | recurse(tilt)) | ., add] as [$dish, $key] | .[1][$key] as $loop
  | last = $dish | .[1][$key] //= first
  | first |= if $loop and ($cycles - .) % (. - $loop) == 1 then $cycles else . + 1 end
) | last | rotate) | load
