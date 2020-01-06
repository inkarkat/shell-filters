#!/usr/bin/env bats

load command

@test "matches and counts are passed to command" {
    run extractMatches --to command --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_runs "text:4
This:5|in:1|it:1|foo
here:7|in:1|it:1|foooo"
}
