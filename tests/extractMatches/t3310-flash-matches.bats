#!/usr/bin/env bats

load flash

@test "single matches in a line are flashed" {
    run extractMatches --unbuffered --to flash --matches fo+ <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously.
EOF
    [ "$output" = "Just some text.
This has ${FOO_M} in it.
All simple lines.
More ${FOOOO_M} here.
Seriously." ]
}

@test "two different matches in a line are flashed" {
    run extractMatches --unbuffered --to flash --matches fo+ --global --matches '\<\w{4}\>' --global <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple text.
More foo here.
Seriously, why?
EOF
    [ "$output" = "${R}Just${N}Just ${R}some${N}some ${R}sexy${N}sexy ${R}text${N}text.
${R}This${N}This has ${FOO_M}, ${FOO_M} and ${FOO_M}${FOO_M} in it.
All simple ${R}text${N}text.
${R}More${N}More ${FOO_M} ${R}here${N}here.
Seriously, why?" ]
}
