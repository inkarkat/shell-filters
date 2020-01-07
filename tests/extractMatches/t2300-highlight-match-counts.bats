#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "single counts in a line are highlighted" {
    run extractMatches --match-count fo+ <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously.
EOF
    [ "$output" = "Just some text.
This has [foo (1)] in it.
All simple lines.
More [foooo (1)] here.
Seriously." ]
}

@test "only the first match in a line is highlighted" {
    run extractMatches --match-count fo+ <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    [ "$output" = "This has [foo (1)], foo and foofoo in it.
More [foooo (1)] and foo here." ]
}

@test "all counts in a line are highlighted with --global" {
    run extractMatches --match-count fo+ --global <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    [ "$output" = "This has [foo (1)], [foo (2)] and [foo (3)][foo (4)] in it.
More [foooo (1)] and [foo (5)] here." ]
}

@test "two different counts in a line are highlighted" {
    run extractMatches --match-count fo+ --global --match-count '\<\w{4}\>' --global <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple text.
More foo here.
Seriously, why?
EOF
    [ "$output" = "[Just (1)] [some (1)] [sexy (1)] [text (1)].
[This (1)] has [foo (1)], [foo (2)] and [foo (3)][foo (4)] in it.
All simple [text (2)].
[More (1)] [foo (5)] [here (1)].
Seriously, why?" ]
}

@test "earlier counts consume those given later" {
    run extractMatches --match-count fo+ --global --match-count oo --global --match-count o+ --global --match-count 'ex' --match-count 'x' --global <<-'EOF'
Just some sexy text.
This has foo, boooo and mooo in it.
EOF
    [ "$output" = "Just s[o (1)]me s[ex (1)]y te[x (1)]t.
This has [foo (1)], b[oo (1)][oo (2)] and m[oo (3)][o (2)] in it." ]
}
