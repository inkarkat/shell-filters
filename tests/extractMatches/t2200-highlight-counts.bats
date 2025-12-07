#!/usr/bin/env bats

load fixture

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "single counts in a line are highlighted" {
    run -0 extractMatches --count fo+ <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
This has [foo (1)] in it.
All simple lines.
More [foo (2)] here.
Seriously.
EOF
}

@test "only the first match in a line is highlighted" {
    run -0 extractMatches --count fo+ <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    assert_output - <<'EOF'
This has [foo (1)], foo and foofoo in it.
More [foooo (2)] and foo here.
EOF
}

@test "all counts in a line are highlighted with --global" {
    run -0 extractMatches --count fo+ --global <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    assert_output - <<'EOF'
This has [foo (1)], [foo (2)] and [foo (3)][foo (4)] in it.
More [foooo (5)] and [foo (6)] here.
EOF
}

@test "three different counts in a line are highlighted" {
    run -0 extractMatches --count fo+ --count 'ex' --count 'y' <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?
EOF
    assert_output - <<'EOF'
Just some s[ex (1)][y (1)] text.
This has [foo (1)], foo and foofoo in it.
All simple lines.
More [foo (2)] here.
Seriousl[y (2)], why?
EOF
}

@test "three different counts with different single / global are highlighted" {
    run -0 extractMatches --count fo+ --global --count 'ex' --count 'y' --global <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?
EOF
    assert_output - <<'EOF'
Just some s[ex (1)][y (1)] text.
This has [foo (1)], [foo (2)] and [foo (3)][foo (4)] in it.
All simple lines.
More [foo (5)] here.
Seriousl[y (2)], wh[y (3)]?
EOF
}

@test "earlier counts consume those given later" {
    run -0 extractMatches --count fo+ --global --count oo --global --count o+ --global --count 'ex' --count 'x' --global <<-'EOF'
Just some sexy text.
This has foo, boooo and mooo in it.
EOF
    assert_output - <<'EOF'
Just s[o (1)]me s[ex (1)]y te[x (1)]t.
This has [foo (1)], b[oo (1)][oo (2)] and m[oo (3)][o (2)] in it.
EOF
}
