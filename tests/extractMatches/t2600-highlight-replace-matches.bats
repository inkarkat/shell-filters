#!/usr/bin/env bats

load fixture

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "plain replacement of match" {
    run -0 extractMatches --regexp fo+ --replacement "FOO" <<-'EOF'
This has foo in it.
More fooo here.
EOF
    assert_output - <<'EOF'
This has [FOO] in it.
More [FOO] here.
EOF
}

@test "prefix replacement of match" {
    run -0 extractMatches --regexp fo+ --replacement "FOO: &" <<-'EOF'
This has foo in it.
More fooo here.
EOF
    assert_output - <<'EOF'
This has [FOO: foo] in it.
More [FOO: fooo] here.
EOF
}

@test "capture group replacement of match" {
    run -0 extractMatches --regexp '(f)(o+)' --replacement "\1-\2" <<-'EOF'
This has foo in it.
More fooo here.
EOF
    assert_output - <<'EOF'
This has [f-oo] in it.
More [f-ooo] here.
EOF
}
