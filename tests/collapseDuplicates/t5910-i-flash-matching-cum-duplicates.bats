#!/usr/bin/env bats

readonly R='[07m'
readonly N='[0m'
readonly LF=$'\r'

@test "duplicate interactive flash of accumulate in multiple locations" {
    run collapseDuplicates --unbuffered --as flash --accumulate 'repeat' <<-'EOF'
This will repeat.
This is the repeat.
That is the last repeat in the first location.
A unique statement.
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
EOF
    [ "$output" = "This will repeat.${LF}${R}This is the repeat.${N}${LF}This is the repeat.${LF}${R}That is the last repeat in the first location.${N}${LF}That is the last repeat in the first location.
A unique statement.
End of interlude.
${R}Another repeat from what we've seen.${N}${LF}Another repeat from what we've seen.${LF}${R}Another repeat yet again.${N}${LF}Another repeat yet again." ]
}
