#!/usr/bin/env bats

load flash

@test "single match-counts in a line are flashed" {
    run extractMatches --unbuffered --to flash --match-count fo+ <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously.
EOF
    [ "$output" = "Just some text.
This has ${FOO_C1} in it.${EOL}
All simple lines.
More ${FOOOO_C1} here.${EOL}
Seriously." ]
}

@test "two different match-counts in a line are flashed" {
    run extractMatches --unbuffered --to flash --match-count fo+ --global --match-count '\<\w{4}\>' --global <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple text.
More foo here.
Seriously, why?
EOF
    [ "$output" = "${R}Just (1)${N}Just ${R}some (1)${N}some ${R}sexy (1)${N}sexy ${R}text (1)${N}text.${EOL}
${R}This (1)${N}This has ${FOO_C1}, ${FOO_C2} and ${FOO_C3}${FOO_C4} in it.${EOL}
All simple ${R}text (2)${N}text.${EOL}
${R}More (1)${N}More ${FOO_C5} ${R}here (1)${N}here.${EOL}
Seriously, why?" ]
}
