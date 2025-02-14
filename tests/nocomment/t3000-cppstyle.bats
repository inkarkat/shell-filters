#!/usr/bin/env bats

load fixture

@test "contents with hash and C/C++/Java // comments" {
    type -t stripcmt >/dev/null || skip 'stripcmt is not available'
    run -0 nocomment <<'EOF'
# First line comment
First text
    // slashslash comment
more text after empty line

mixed # with comment
mixed // with comment
no#a comment
# More comments
//
// as well
The end
EOF
    assert_output - <<'EOF'
First text

more text after empty line

mixed
mixed
no#a comment


The end
EOF
}

@test "contents with hash and C/C++/Java /* ... */ comments" {
    type -t stripcmt >/dev/null || skip 'stripcmt is not available'
    run -0 nocomment <<'EOF'
# First line comment
First text
    /* slashslash comment */
more text after empty line

mixed # with comment
mixed /* with comment */
no#a comment
# More comments
/*
 * as well
 */
The end
EOF
    assert_output - <<'EOF'
First text

more text after empty line

mixed
mixed
no#a comment



The end
EOF
}
