#!/usr/bin/env bats

export EXTRACTMATCHES_CONCATENATED_UPDATE_DELAY=1

load log

@test "single matches in a line are shown as concatenated lines every second and at the end" {
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
    } | extractMatches --to concatenated --count 'foo[0-9]+' --global --count 'ex' --count 'y' --global > "$LOG"
    assert_log "Just sexy text.
This has foo2 in it.
All foo3.
More foo4 here.
Making a rest.
That foo5.
extracted matches: foo5: 4, ex: 1, y: 1
Rex' foo6.
Your foo7.
Last foo8.
Seriously.
extracted matches: foo8: 7, ex: 2, y: 2"
}
