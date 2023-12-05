#!/usr/bin/env -S jq -Rnf

# AoC 2023/05 in jq 1.7

[inputs] | [(join(",") / ",,")[] / "," | map([scan("\\d+") | tonumber])]
| [(.[0][0] | map([.,1]), [_nwise(2)]), .[1:][] | map((.[-1] += .[-2])?)]
| .[:2][] as $seed | .[2:] | map(map(.[0] -= .[1]))

| reduce .[] as $map ($seed; reduce $map[] as $r ([.,[]]; reduce first[] as $q (first = [];
    if ($q[0] - $r[2]) * ($q[1] - $r[1]) > 0 then first += [$q] else
      ($q + $r[1:] | sort) as $seg | last += [[$seg[1,2] + $r[0]]]
      | first += [[$q[0], $seg[1]], [$seg[2], $q[1]] | select(first < last)]
    end
  )) | add) | map(first) | min
