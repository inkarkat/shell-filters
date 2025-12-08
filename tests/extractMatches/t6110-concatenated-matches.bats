#!/usr/bin/env bats

load fixture

@test "single matches in a line are shown in concatenated line" {
    input="Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously."
    run -0 extractMatches --to concatenated --regexp fo+ <<<"$input"
    assert_output - <<'EOF'
Just some text.
This has foo in it.
extracted matches: foo
All simple lines.
More foo here.
Seriously.
EOF
}

@test "three different matches with different single / global are shown in concatenated line" {
    input="Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?"
    run -0 extractMatches --to concatenated --regexp fo+ --global --regexp 'ex' --regexp 'y' --global <<<"$input"
    assert_output - <<'EOF'
Just some sexy text.
extracted matches: y
This has foo, foo and foofoo in it.
extracted matches: foo
All simple lines.
More foo here.
Seriously, why?
extracted matches: y
EOF
}
