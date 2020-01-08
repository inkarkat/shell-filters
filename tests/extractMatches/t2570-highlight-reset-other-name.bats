#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "single counts in a line are reset via name by another count" {
    run extractMatches --count fo+ --name foos --count All --reset-other foos <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously.
EOF
    [ "$output" = "Just some text.
This has [foo (1)] in it.
[All (1)] simple lines.
More [foooo (1)] here.
Seriously." ]
}

@test "counts within a line are reset via name by an intermediate reset match" {
    run extractMatches --count fo+ --name foos --global --regexp and --reset-other foos <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    [ "$output" = "This has [foo (1)], [foo (2)] [and] [foo (1)][foo (2)] in it.
More [foooo (3)] [and] [foo (1)] here." ]
}

@test "two different counts in a line are reset via names of other counts" {
    run extractMatches --match-count fo+ --name foos --global --count '[Aa]nd' --reset-other foos --match-count '\<\w{4}\>' --name fours --global --count '[Oo]r' --reset-other fours <<-'EOF'
Or some sexy text.
This text has foo, or foo and foofoo in it.
All simple text.
And more foo text here.
Or foo text.
EOF
    [ "$output" = "[Or (1)] [some (1)] [sexy (1)] [text (1)].
[This (1)] [text (2)] has [foo (1)], [or (2)] [foo (2)] [and (1)] [foo (1)][foo (2)] in it.
All simple [text (1)].
[And (2)] [more (1)] [foo (1)] [text (2)] [here (1)].
[Or (3)] [foo (2)] [text (1)]." ]
}
