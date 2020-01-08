#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "single counts in a line are reset via name by another line" {
    run extractMatches --count fo+ --name foos --reset-name All --name foos <<-'EOF'
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

@test "counts within a line are reset by an intermediate reset pattern that comes first" {
    run extractMatches --reset-name and --name foos --count fo+ --global --name foos <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    [ "$output" = "This has [foo (1)], [foo (2)] and [foo (1)][foo (2)] in it.
More [foooo (3)] and [foo (1)] here." ]
}

@test "two different counts are reset" {
    run extractMatches --match-count fo+ --global --name foos --reset-name '[Aa]nd' --name foos --match-count '\<\w{4}\>' --global --name fours --reset-name '[Oo]r' --name fours <<-'EOF'
Or some sexy text.
This text has foo, or foo and foofoo in it.
All more simple text.
And more foo text here.
Or foo text.
EOF
    [ "$output" = "Or [some (1)] [sexy (1)] [text (1)].
[This (1)] [text (2)] has [foo (1)], or [foo (2)] and [foo (1)][foo (2)] in it.
All [more (1)] simple [text (1)].
And [more (2)] [foo (1)] [text (2)] [here (1)].
Or [foo (2)] [text (1)]." ]
}

@test "count and match-counts are reset" {
    run extractMatches --count fo+ --global --name foos --reset-name '[Aa]nd' --name foos --match-count '\<\w{4}\>' --global --name fours --reset-name '[Oo]r' --name fours <<-'EOF'
Or some sexy text.
This text has foo, or foo and foofoo in it.
All more simple text.
And more foooo text here.
Or foooooo text.
EOF
    [ "$output" = "Or [some (1)] [sexy (1)] [text (1)].
[This (1)] [text (2)] has [foo (1)], or [foo (2)] and [foo (1)][foo (2)] in it.
All [more (1)] simple [text (1)].
And [more (2)] [foooo (1)] [text (2)] [here (1)].
Or [foooooo (2)] [text (1)]." ]
}

@test "earlier counts consume those given later" {
    run extractMatches --match-count fo+ --global --match-count oo --global --name double-o --reset-name and --name double-o --match-count o+ --global --match-count 'ex' --match-count 'x' --global <<-'EOF'
Just some sexy text.
This has foo, boooo and mooo in it.
EOF
    [ "$output" = "Just s[o (1)]me s[ex (1)]y te[x (1)]t.
This has [foo (1)], b[oo (1)][oo (2)] and m[oo (1)][o (2)] in it." ]
}
