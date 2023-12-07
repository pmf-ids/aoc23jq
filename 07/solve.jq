#!/usr/bin/env -S jq -Rnf

# AoC 2023/07 in jq 1.7

[inputs/" "] | ("\(1,"J")23456789TJQKA"/"") as $cr | map(first |= (./"" | map($cr[[.]][0])
  | (group_by(. > 0) | map(group_by(.) | map(-length) | sort) | transpose | map(-add)) + .
)) | sort | to_entries | map((.key + 1) * (.value | last | tonumber)) | add
