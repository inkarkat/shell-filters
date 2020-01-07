#!/usr/bin/env bats

export EXTRACTMATCHES_NOTIFY_UPDATE_DELAY=-3
load notify

@test "delayed matches and counts are notify-sent with two-line input" {
    run extractMatches --to notify  --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<-'EOF'
Just sexy text.
Even has foo in it.
EOF
    assert_runs "${PREFIX}Even:4|in:1|it:1|foo"
}
