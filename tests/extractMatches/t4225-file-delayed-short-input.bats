#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_DELAY=-3
load log

@test "delayed matches and counts are written with two-line input" {
    run extractMatches --to "$LOG" --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<-'EOF'
Just sexy text.
Even has foo in it.
EOF
    assert_log "foo
Even: 4
in: 1
it: 1"
}
