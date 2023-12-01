# Solving [Advent of Code](https://adventofcode.com/) [2023](https://adventofcode.com/2023/) in [jq](https://jqlang.github.io/jq/) [1.7](https://github.com/jqlang/jq/releases/tag/jq-1.7)

The solutions presented here are written in
jq 1.7, which was released on September 7, 2023. They require
invoking `jq` with some flags (mostly `-R` and `-n`), which are
specified in the example invocations preceding each code section
below, using `solve.jq` and `input.txt` as filenames for the
source code and the input data, respectively. The actual source
code files in this repository, however, also contain a corresponding
shebang prefix, so running them with just `./solve.jq input.txt`
(and execution permissions set) should equally be possible on
most Unix-like operating systems.

## [🖿 01](01) solving [Day 1: Trebuchet?!](https://adventofcode.com/2023/day/1)
`jq -Rnf solve.jq input.txt`
```jq
[inputs / ""] | ., map(reduce (
  [[], indices(("one two three four five six seven eight nine" / " ")[] / "")]
  | to_entries[] | .value = .value[] + 1
) as $e (.; .[$e.value] = $e.key)) | map(map(tonumber?) | first * 10 + last)? | add
```
