#!/usr/bin/env -S jq -Rnf

# AoC 2023/09 in jq 1.7

[inputs / " "| map(tonumber)] | ., map(reverse)
| map([while(any(. != 0); [.[range(length - 1):] | .[1] - .[0]]) | last] | add) | add
