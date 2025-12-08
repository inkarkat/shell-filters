#!/usr/bin/env bats

load flash

@test "error when flash is used with buffered output" {
    run -2 extractMatches --to flash --regexp fo+
    assert_line -n 0 "ERROR: Flash reporting must be combined with --unbuffered."
    assert_line -n 1 -e '^Usage:'
}

@test "single matches in a line are flashed" {
    run -0 extractMatches --unbuffered --to flash --regexp fo+ <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously.
EOF
    assert_output - <<EOF
Just some text.
This has ${FOO_M} in it.
All simple lines.
More ${FOO_M} here.
Seriously.
EOF
}

@test "three different matches with different single / global are flashed" {
    run -0 extractMatches --unbuffered --to flash --regexp fo+ --global --regexp 'ex' --regexp 'y' --global <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?
EOF
    assert_output - <<EOF
Just some s${R}ex${N}ex${R}y${N}y text.
This has ${FOO_M}, ${FOO_M} and ${FOO_M}${FOO_M} in it.
All simple lines.
More ${FOO_M} here.
Seriousl${R}y${N}y, wh${R}y${N}y?
EOF
}
