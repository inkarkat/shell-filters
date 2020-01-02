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
