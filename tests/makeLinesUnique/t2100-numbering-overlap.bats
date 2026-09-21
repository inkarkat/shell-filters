#!/usr/bin/env bats

load fixture

@test "appended (1) numbering yields another following input line" {
    run -0 makeLinesUnique <<'EOF'
foo
foo (1)
bar
baz
foo
quux
EOF
    assert_output - <<'EOF'
foo (1) (1)
foo (1) (2)
bar
baz
foo (2)
quux
EOF
}

@test "appended (1) numbering yields another preceding input line" {
    run -0 makeLinesUnique <<'EOF'
foo (1)
foo
bar
baz
foo
quux
EOF
    assert_output - <<'EOF'
foo (1) (1)
foo (1) (2)
bar
baz
foo (2)
quux
EOF
}

@test "appended (2) numbering yields another following input line" {
    run -0 makeLinesUnique <<'EOF'
foo
foo (2)
bar
baz
foo
quux
EOF
    assert_output - <<'EOF'
foo (1)
foo (2) (1)
bar
baz
foo (2) (2)
quux
EOF
}

@test "appended (2) numbering yields another preceding input line" {
    run -0 makeLinesUnique <<'EOF'
foo (2)
foo
bar
baz
foo
quux
EOF
    assert_output - <<'EOF'
foo (2) (1)
foo (1)
bar
baz
foo (2) (2)
quux
EOF
}
