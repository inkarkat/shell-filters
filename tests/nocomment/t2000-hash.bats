#!/usr/bin/env bats

load fixture

@test "contents with hash comments" {
    run -0 nocomment <<'EOF'
# First line comment
First text
more text after empty line

mixed # with comment
no#a comment
# More comments
#
# as well
The end
EOF
    assert_output - <<'EOF'
First text
more text after empty line

mixed
no#a comment
The end
EOF
}
