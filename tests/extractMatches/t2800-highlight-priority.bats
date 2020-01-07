#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "matches with three different priorities in a line are highlighted" {
    run extractMatches --regexp fo+ --global --priority 10 --regexp 'e\w' --priority 1 --regexp 'y' --global --priority 2 <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?
EOF
    [ "$output" = "Just some s[ex][y] text.
This has [foo], [foo] and [foo][foo] in it.
All simple lines.
More [foo] here.
Seriously, why?" ]
}

@test "matches with negative and positive priorities and a default priority in a line are highlighted" {
    run extractMatches --regexp fo+ --global --priority 1 --regexp 'e\w' --priority -1 --regexp 'y' --global <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?
EOF
    [ "$output" = "Just some s[ex][y] text.
This has [foo], [foo] and [foo][foo] in it.
All simple lines.
More [foo] here.
Seriously, why?" ]
}

@test "counts with negative and positive priorities and a default priority in a line are highlighted" {
    run extractMatches --match-count fo+ --global --priority 1 --count 'e\w' --priority -1 --count 'y' --global <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foooo here.
Seriously, why?
EOF
    [ "$output" = "Just some s[ex (1)][y (1)] text.
This has [foo (1)], [foo (2)] and [foo (3)][foo (4)] in it.
All simple lines.
More [foooo (1)] here.
Seriously, why?" ]
}
