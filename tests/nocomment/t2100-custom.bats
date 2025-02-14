#!/usr/bin/env bats

load fixture

@test "contents with custom semicolon comments" {
    NOCOMMENT_EXPR=\; run -0 nocomment <<'EOF'
# First line hash comment
First text
; semicolon comment
more text after empty line

mixed ; with comment
no;a comment
; More comments
;
; as well
The end
EOF
    assert_output - <<'EOF'
# First line hash comment
First text
more text after empty line

mixed
no;a comment
The end
EOF
}

@test "contents with added custom semicolon comments" {
    NOCOMMENT_EXPR='[;#]' run -0 nocomment <<'EOF'
# First line hash comment
First text
; semicolon comment
more text after empty line

mixed ; with comment
no;a comment
; More comments
;
; as well
The end
EOF
    assert_output - <<'EOF'
First text
more text after empty line

mixed
no;a comment
The end
EOF
}

@test "contents with custom semicolon and // comments" {
    NOCOMMENT_EXPR=';\|//' run -0 nocomment <<'EOF'
# First line hash comment
First text
    ; semicolon comment
    // slashslash comment
more text after empty line

mixed ; with comment
mixed // with comment
no;a comment
; More comments
;
// as well
The end
EOF
    assert_output - <<'EOF'
# First line hash comment
First text
more text after empty line

mixed
mixed
no;a comment
The end
EOF
}
