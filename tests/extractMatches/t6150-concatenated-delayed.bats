#!/usr/bin/env bats

export EXTRACTMATCHES_CONCATENATED_UPDATE_DELAY=-3

load log

@test "matches and counts are shown as concatenated lines every 3 lines and at the end" {
    run -0 extractMatches --to concatenated --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    assert_output - <<'EOF'
Just sexy text.
This has foo2 in it.
All foo3.
extracted matches: This: 4, in: 1, it: 1, foo
More foo4 here.
That foo5.
Rex' foo6.
extracted matches: That: 7, in: 1, it: 1, foo
Your foo7.
Last foo8.
Seriously.
extracted matches: Last: 9, in: 1, it: 1, foo
EOF
}
