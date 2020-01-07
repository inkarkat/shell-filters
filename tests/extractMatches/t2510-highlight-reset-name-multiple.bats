#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "two different patterns with joined counts are reset by the same reset-pattern" {
    run extractMatches --count fo+ --global --name joined --reset-name '\<[Aa]nd\>' --name joined --count '\<text\>' --global --name joined --count '\<[Oo]r\>' <<-'EOF'
Or some sexy text.
This text has foo, or foo and foofoo in it.
All simple text.
And more foo text here.
Or foo text.
EOF
    [ "$output" = "[Or (1)] some sexy [text (1)].
This [text (2)] has [foo (3)], [or (2)] [foo (4)] and [foo (1)][foo (2)] in it.
All simple [text (3)].
And more [foo (1)] [text (2)] here.
[Or (3)] [foo (3)] [text (4)]." ]
}

@test "two different counts are reset by name-pattern" {
    run extractMatches --count fo+ --global --name foos --reset-name '\<[Aa]nd\>' --name '/^fo(o|ur)s$/' --count '\<text\>' --global --name fours --count '\<[Oo]r\>' <<-'EOF'
Or some sexy text.
This text has foo, or foo and foofoo in it.
All simple text.
And more foo text here.
Or foo text.
EOF
    [ "$output" = "[Or (1)] some sexy [text (1)].
This [text (2)] has [foo (1)], [or (2)] [foo (2)] and [foo (1)][foo (2)] in it.
All simple [text (1)].
And more [foo (1)] [text (1)] here.
[Or (3)] [foo (2)] [text (2)]." ]
}

@test "some match-counts are reset by name-pattern" {
    run extractMatches --match-count '\<\w{4}\>' --global --name fours --reset-name '\<[Aa]nd\>' --name '/^fours-[st]/' --reset-name '\<[Oo]r\>' --name 'fours-fooo' <<-'EOF'
Or some more sexy text.
This text has fooo, or fooo and fooo fooo in it.
All simple text.
And more sexy fooo text here.
Or some fooo text.
EOF
    [ "$output" = "Or [some (1)] [more (1)] [sexy (1)] [text (1)].
[This (1)] [text (2)] has [fooo (1)], or [fooo (1)] and [fooo (2)] [fooo (3)] in it.
All simple [text (1)].
And [more (2)] [sexy (1)] [fooo (4)] [text (1)] [here (1)].
Or [some (1)] [fooo (1)] [text (2)]." ]
}
