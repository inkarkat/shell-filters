#!/usr/bin/env bats

load flash
export EXTRACTMATCHES_FLASH_REPEATS=3

@test "single matches in a line are flashed three times" {
    run extractMatches --unbuffered --to flash --regexp fo+ <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously.
EOF
    [ "$output" = "Just some text.
This has ${FOO_M}${FOO_M}${FOO_M} in it.
All simple lines.
More ${FOO_M}${FOO_M}${FOO_M} here.
Seriously." ]
}

@test "two different matches with different single / global are flashed three times" {
    run extractMatches --unbuffered --to flash --count fo+ --global --count 'x' <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
EOF
    [ "$output" = "Just some se${X1}${X1}${X1f}y text.${EOL}
This has ${FOO1}${FOO1}${FOO1f}, ${FOO2}${FOO2}${FOO2f} and ${FOO3}${FOO3}${FOO3f}${FOO4}${FOO4}${FOO4f} in it.${EOL}" ]
}
