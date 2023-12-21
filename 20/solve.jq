#!/usr/bin/env -S jq -Rnf

# AoC 2023/20 in jq 1.7

[inputs | [scan("(%|&)?(\\w+)")] | {id:.[0][1], type:.[0][0], to:[.[1:][][1]]}]
| reduce (.[] | .to = .to[]) as {$id, $to} (INDEX(.id); .[$to].from[$id] = false)
| reduce (.rx.from | keys[]) as $rx (.; .rx.from[$rx] = .[$rx].from)? // . | {mods: .}

| until(all((.mods.rx.from[][])?, .btn >= 1000; .); .mods.broadcaster as {$to}
    | .btn += 1 | .false += ($to | length + 1) | .q += [{to: $to[]}]
    | until(.q == []; .q as [{$id, $to, $ps}] | .q |= .[1:] | ."\($ps)" += 1
        | if $to == "rx" then (.mods | (.rx.from | keys[]) as $rx
            | .rx.from[$rx][.[$rx].from | keys[] as $id | select(.[$id]) | $id]) //= .btn
          elif .mods[$to].type == "&" then .mods[$to].from[$id] = $ps
            | .q += [.mods[$to] | {id: $to, to: .to[], ps: any(.from[]; not)}?]
          else select($ps) // (.mods[$to].ps |= not
            | .q += [.mods[$to] | {id: $to, to: .to[], ps}?])
          end
      )
    | if .btn == 1000 then .warmup = .true * .false end
  )

| .warmup, reduce .mods.rx.from[][] as $n (1;
    . * $n / ([., $n] | until(last == 0; [last, first % last]) | first) # lcm
  )?
