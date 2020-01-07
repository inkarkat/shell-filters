#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "single counts in a line are highlighted" {
    run extractMatches --count fo+ <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously.
EOF
    [ "$output" = "Just some text.
This has [foo (1)] in it.
All simple lines.
More [foo (2)] here.
Seriously." ]
}

@test "only the first match in a line is highlighted" {
    run extractMatches --count fo+ <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    [ "$output" = "This has [foo (1)], foo and foofoo in it.
More [foooo (2)] and foo here." ]
}

@test "all counts in a line are highlighted with --global" {
    run extractMatches --count fo+ --global <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    [ "$output" = "This has [foo (1)], [foo (2)] and [foo (3)][foo (4)] in it.
More [foooo (5)] and [foo (6)] here." ]
}

@test "three different counts in a line are highlighted" {
    run extractMatches --count fo+ --count 'ex' --count 'y' <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?
EOF
    [ "$output" = "Just some s[ex (1)][y (1)] text.
This has [foo (1)], foo and foofoo in it.
All simple lines.
More [foo (2)] here.
Seriousl[y (2)], why?" ]
}

@test "three different counts with different single / global are highlighted" {
    run extractMatches --count fo+ --global --count 'ex' --count 'y' --global <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?
EOF
    [ "$output" = "Just some s[ex (1)][y (1)] text.
This has [foo (1)], [foo (2)] and [foo (3)][foo (4)] in it.
All simple lines.
More [foo (5)] here.
Seriousl[y (2)], wh[y (3)]?" ]
}

@test "earlier counts consume those given later" {
    run extractMatches --count fo+ --global --count oo --global --count o+ --global --count 'ex' --count 'x' --global <<-'EOF'
Just some sexy text.
This has foo, boooo and mooo in it.
EOF
    [ "$output" = "Just s[o (1)]me s[ex (1)]y te[x (1)]t.
This has [foo (1)], b[oo (1)][oo (2)] and m[oo (3)][o (2)] in it." ]
}
