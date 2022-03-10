#!/usr/bin/env bats

load sweeper

readonly LF=$'\r'

@test "interactive match sweeping of accumulate in multiple locations" {
    run collapseDuplicates --unbuffered --as sweep --accumulate 'repeat' <<-'EOF'
This will repeat.
This is the repeat.
That is the last repeat in the first location.
A unique statement.
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
EOF
    [ "$output" = "This will repeat.${LF}This is the repeat. [    ]${LF}That is the last repeat in the first location. [*   ]
A unique statement.
End of interlude.
Another repeat from what we've seen. [-*  ]${LF}Another repeat yet again. [ -* ]" ]
}
