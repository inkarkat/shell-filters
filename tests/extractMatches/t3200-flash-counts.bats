#!/usr/bin/env bats

load flash

@test "single counts in a line are flashed" {
    run extractMatches --unbuffered --to flash --count fo+ <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously.
EOF
    [ "$output" = "Just some text.
This has ${FOO_C1} in it.${EOL}
All simple lines.
More ${FOO_C2} here.${EOL}
Seriously." ]
}

@test "three different counts with different single / global are flashed" {
    run extractMatches --unbuffered --to flash --count fo+ --global --count 'ex' --count 'y' --global <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?
EOF
    [ "$output" = "Just some s${R}ex (1)${N}ex${R}y (1)${N}y text.${EOL}
This has ${FOO_C1}, ${FOO_C2} and ${FOO_C3}${FOO_C4} in it.${EOL}
All simple lines.
More ${FOO_C5} here.${EOL}
Seriousl${R}y (2)${N}y, wh${R}y (3)${N}y?${EOL}" ]
}
