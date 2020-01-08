#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "another counts is reset by reset-pattern" {
    run extractMatches --count fo+ --global --reset All --reset-other '\<text\>' --count '\<text\>' --global <<-'EOF'
Or some sexy text.
This text has foo, or foo and foofoo in it.
All simple text.
And more foo text here.
Or foo text.
EOF
    [ "$output" = "Or some sexy [text (1)].
This [text (2)] has [foo (1)], or [foo (2)] and [foo (3)][foo (4)] in it.
All simple [text (1)].
And more [foo (1)] [text (2)] here.
Or [foo (2)] [text (3)]." ]
}

@test "two other counts are reset by pattern and reset-pattern of a third count" {
    run extractMatches --count fo+ --global --count '\<[Oo]r\>' --global --reset-other fo+ --reset All --reset-other '\<text\>' --count '\<text\>' --global <<-'EOF'
Or some sexy text.
This text has foo, or foo and foofoo text in it.
All simple text.
And more foo text here.
Or foo text.
EOF
    [ "$output" = "[Or (1)] some sexy [text (1)].
This [text (2)] has [foo (1)], [or (2)] [foo (1)] and [foo (2)][foo (3)] [text (3)] in it.
All simple [text (1)].
And more [foo (4)] [text (2)] here.
[Or (1)] [foo (1)] [text (3)]." ]
}
