#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "single matches in a line are highlighted" {
    run extractMatches --regexp fo+ <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously.
EOF
    [ "$output" = "Just some text.
This has [foo] in it.
All simple lines.
More [foo] here.
Seriously." ]
}

@test "only the first match in a line is highlighted" {
    run extractMatches --regexp fo+ <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    [ "$output" = "This has [foo], foo and foofoo in it.
More [foooo] and foo here." ]
}

@test "all matches in a line are highlighted with --global" {
    run extractMatches --regexp fo+ --global <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    [ "$output" = "This has [foo], [foo] and [foo][foo] in it.
More [foooo] and [foo] here." ]
}

@test "three different matches in a line are highlighted" {
    run extractMatches --regexp fo+ --regexp 'ex' --regexp 'y' <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?
EOF
    [ "$output" = "Just some s[ex][y] text.
This has [foo], foo and foofoo in it.
All simple lines.
More [foo] here.
Seriousl[y], why?" ]
}

@test "three different matches with different single / global are highlighted" {
    run extractMatches --regexp fo+ --global --regexp 'ex' --regexp 'y' --global <<-'EOF'
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
Seriousl[y], wh[y]?" ]
}

@test "earlier matches consume those given later" {
    run extractMatches --regexp fo+ --global --regexp oo --global --regexp o+ --global --regexp 'ex' --regexp 'x' --global <<-'EOF'
Just some sexy text.
This has foo, boooo and mooo in it.
EOF
    [ "$output" = "Just s[o]me s[ex]y te[x]t.
This has [foo], b[oo][oo] and m[oo][o] in it." ]
}
