#!/usr/bin/env bats

load overlay

export EXTRACTMATCHES_OVERLAY_ERASE='[0K'
readonly C="][0m${EXTRACTMATCHES_OVERLAY_ERASE}[u"

@test "single matches in a line are overlaid and cleared with custom configuration" {
    input="Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously."
    run extractMatches --to overlay --regexp fo+ <<<"$input"
    [ "$output" = "Just some text.
This has foo in it.
${R}foo${C}All simple lines.
${R}foo${C}More foo here.
${R}foo${C}Seriously.
${R}foo${C}" ]
}
