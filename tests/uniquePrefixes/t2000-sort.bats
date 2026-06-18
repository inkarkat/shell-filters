#!/usr/bin/env bats

load fixture

@test "single line" {
    run -0 uniquePrefixes <<<'foobar'
    assert_output 'foobar'
}

@test "unique lines are sorted" {
    run -0 uniquePrefixes <<'EOF'
foe
friend
foobar
EOF
    assert_output - <<'EOF'
foe
foobar
friend
EOF
}

@test "identical lines are de-duplicated" {
    run -0 uniquePrefixes <<'EOF'
foobar
foobar
friend
foe
friend
foobar
EOF
    assert_output - <<'EOF'
foe
foobar
friend
EOF
}

@test "prefix lines are de-duplicated" {
    run -0 uniquePrefixes <<'EOF'
foobar
foo
friend
friendship
f
foe
friend
foob
fooba
EOF
    assert_output - <<'EOF'
foe
foobar
friendship
EOF
}

@test "suffix and middle lines are not de-duplicated" {
    run -0 uniquePrefixes <<'EOF'
bar
ob
foobar
oobar
EOF
    assert_output - <<'EOF'
bar
foobar
ob
oobar
EOF
}
