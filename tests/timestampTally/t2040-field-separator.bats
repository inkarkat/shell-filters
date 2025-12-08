#!/usr/bin/env bats

load fixture

input="my_1593871643_foo_la
me_1593871644_bar
you_1593871648_baz"

@test "discontinuous epochs as specified second field with underscore field separator are printed with custom field separator" {
    run -0 timestampTally --field-separator _ --timestamp-field 2 <<<"$input"
    assert_output - <<'EOF'
my_0_foo_la
me_0_bar
you_0_baz
EOF
}

@test "discontinuous epochs as specified second field with regexp field separator are printed default space field separator" {
    run -0 timestampTally --field-separator '[_~]' --timestamp-field 2 <<<"$input"
    assert_output - <<'EOF'
my 0 foo la
me 0 bar
you 0 baz
EOF
}
