#!/usr/bin/env bats

load command

@test "single matches in a line are passed to command every second and at the end" {
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
    } | extractMatches --to command --count 'foo[0-9]+' --global --count 'ex' --count 'y' --global
    assert_runs "foo5:4|ex:1|y:1
foo8:7|ex:2|y:2"
}
