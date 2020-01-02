#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "single counts in a line are reset by another line" {
    run extractMatches --count fo+ --reset All <<-'EOF'
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

@test "counts within a line are reset by an intermediate reset pattern" {
    run extractMatches --count fo+ --global --reset and <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    [ "$output" = "This has [foo (1)], [foo (2)] and [foo (1)][foo (2)] in it.
More [foooo (3)] and [foo (1)] here." ]
}

@test "two different counts in a line are highlighted" {
    run extractMatches --match-count fo+ --global --reset '[Aa]nd' --match-count '\<\w{4}\>' --global --reset '[Oo]r' <<-'EOF'
Or some sexy text.
This text has foo, or foo and foofoo in it.
All simple text.
And more foo text here.
Or foo text.
EOF
    [ "$output" = "Or [some (1)] [sexy (1)] [text (1)].
[This (1)] [text (2)] has [foo (1)], or [foo (2)] and [foo (1)][foo (2)] in it.
All simple [text (1)].
And [more (1)] [foo (1)] [text (2)] [here (1)].
Or [foo (2)] [text (1)]." ]
}

@test "earlier counts consume those given later" {
    run extractMatches --match-count fo+ --global --match-count oo --global --reset and --match-count o+ --global --match-count 'ex' --match-count 'x' --global <<-'EOF'
Just some sexy text.
This has foo, boooo and mooo in it.
EOF
    [ "$output" = "Just s[o (1)]me s[ex (1)]y te[x (1)]t.
This has [foo (1)], b[oo (1)][oo (2)] and m[oo (1)][o (2)] in it." ]
}
