#!/usr/bin/env bats

load flash

@test "error when flash is used with buffered output" {
    run extractMatches --to flash --regexp fo+

    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Flash reporting must be combined with --unbuffered." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "single matches in a line are flashed" {
    run extractMatches --unbuffered --to flash --regexp fo+ <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously.
EOF
    [ "$output" = "Just some text.
This has ${R}foo${N}foo in it.
All simple lines.
More ${R}foo${N}foo here.
Seriously." ]
}

@test "three different matches with different single / global are highlighted" {
    run extractMatches --unbuffered --to flash --regexp fo+ --global --regexp 'ex' --regexp 'y' --global <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?
EOF
    [ "$output" = "Just some s${R}ex${N}ex${R}y${N}y text.
This has ${R}foo${N}foo, ${R}foo${N}foo and ${R}foo${N}foo${R}foo${N}foo in it.
All simple lines.
More ${R}foo${N}foo here.
Seriousl${R}y${N}y, wh${R}y${N}y?" ]
}
