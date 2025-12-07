#!/usr/bin/env bats

export EXTRACTMATCHES_COMMAND_UPDATE_DELAY=-3

load command

@test "delayed matches and counts are passed to command with two-line input" {
    run -0 extractMatches --to command  --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<-'EOF'
Just sexy text.
Even has foo in it.
EOF
    assert_runs "Even:4|in:1|it:1|foo"
}
