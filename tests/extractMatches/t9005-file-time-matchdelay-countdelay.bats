#!/usr/bin/env bats

load log

@test "matches are written to a file every second, counts only every two seconds" {
    export EXTRACTMATCHES_FILE_UPDATE_MATCH_DELAY=1
    export EXTRACTMATCHES_FILE_UPDATE_COUNT_DELAY=2
    {
    cat <<'EOF'
Just sexy text.
This has foo2 in it.
All foo3.
More foo4 here.
Making a rest.
EOF
    sleep 1.1
    cat <<'EOF'
That foo5.
Rex' foo6.
Your foo7.
Last foo8.
Seriously.
EOF
    sleep 1.1
    cat <<'EOF'
extra foo10.
Yay.
Bonus foo12.
Look foo13.
Fatally.
EOF
    } | extractMatches --to "$LOG" --regexp 'foo[0-9]+' --global --count 'ex' --count 'y' --global
    assert_log "foo5
foo10
ex: 3
y: 2
foo13
y: 4"
}
