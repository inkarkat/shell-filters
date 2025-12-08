#!/usr/bin/env bats

load fixture

readonly LF=$'\r'

@test "duplicate interactive ellipsis of accumulate in multiple locations" {
    run -0 collapseDuplicates --unbuffered --as ellipsis --accumulate 'repeat' <<-'EOF'
This will repeat.
This is the repeat.
That is the last repeat in the first location.
A unique statement.
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
EOF
    assert_output - <<EOF
This will repeat.${LF}This is the repeat. [...]${LF}That is the last repeat in the first location. [...]
A unique statement.
End of interlude.
Another repeat from what we've seen. [...]${LF}Another repeat yet again. [...]
EOF
}
