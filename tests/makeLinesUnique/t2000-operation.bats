#!/usr/bin/env bats

load fixture

@test "no change to already unique input" {
    run -0 makeLinesUnique <<'EOF'
foo
bar
baz
EOF
    assert_output - <<'EOF'
foo
bar
baz
EOF
}

@test "append numbering to one duplicated consecutive line" {
    run -0 makeLinesUnique <<'EOF'
f
fo
foo
foo
foo
foo
bar
baz
quux
EOF
    assert_output - <<'EOF'
f
fo
foo (1)
foo (2)
foo (3)
foo (4)
bar
baz
quux
EOF
}

@test "append numbering to one duplicated line" {
    run -0 makeLinesUnique <<'EOF'
f
fo
foo
bar
foo
baz
foo
foo
quux
EOF
    assert_output - <<'EOF'
f
fo
foo (1)
bar
foo (2)
baz
foo (3)
foo (4)
quux
EOF
}

@test "append numbering to multiple duplicated lines" {
    run -0 makeLinesUnique <<'EOF'
f
fo
foo
bar
foo
baz
bar
foo
foo
quux
f
EOF
    assert_output - <<'EOF'
f (1)
fo
foo (1)
bar (1)
foo (2)
baz
bar (2)
foo (3)
foo (4)
quux
f (2)
EOF
}
