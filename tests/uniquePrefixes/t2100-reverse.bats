#!/usr/bin/env bats

load fixture

@test "unique lines are reverse-sorted" {
    run -0 uniquePrefixes --reverse <<'EOF'
foe
friend
foobar
EOF
    assert_output - <<'EOF'
friend
foobar
foe
EOF
}

@test "identical lines are de-duplicated and reversed" {
    run -0 uniquePrefixes --reverse <<'EOF'
foobar
foobar
friend
foe
friend
foobar
EOF
    assert_output - <<'EOF'
friend
foobar
foe
EOF
}

@test "prefix lines are de-duplicated and reversed" {
    run -0 uniquePrefixes --reverse <<'EOF'
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
friendship
foobar
foe
EOF
}
