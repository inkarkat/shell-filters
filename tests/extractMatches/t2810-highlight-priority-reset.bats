#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "resets of different priorities re-enable lower-prio highlighting" {
    run extractMatches --match-count fo+ --global --priority 2 --reset 'fx+' --match-count '\<\w{4}\>' --priority 1 --global --reset '----' --count 'low' --global --regexp 'super' --priority 3 --reset 'nosuper' <<-'EOF'
A low sexy text.
In a more low ---- low voice.
This text has foo, or foo and super foofoo in it.
A nosuper low more foo but simple text.
fxx low more foo text here.
---- here foo text.
EOF
    [ "$output" = "A [low (1)] [sexy (1)] [text (1)].
In a [more (1)] low ---- [low (2)] voice.
[This (1)] [text (1)] has [foo (1)], or [foo (2)] and [super] foofoo in it.
A nosuper low more [foo (3)] but simple text.
fxx low [more (1)] [foo (1)] text here.
---- [here (1)] [foo (2)] text." ]
}


@test "equivalent named resets of different priorities re-enable lower-prio highlighting" {
    run extractMatches --match-count fo+ --global --priority 2 --name foos --reset-name 'fx+' --priority 2 --name foos --match-count '\<\w{4}\>' --priority 1 --name fours --global --reset-name '----' --priority 1 --name fours --count 'low' --global --regexp 'super' --priority 3 --name super --reset-name 'nosuper' --priority 3 --name super <<-'EOF'
A low sexy text.
In a more low ---- low voice.
This text has foo, or foo and super foofoo in it.
A nosuper low more foo but simple text.
fxx low more foo text here.
---- here foo text.
EOF
    [ "$output" = "A [low (1)] [sexy (1)] [text (1)].
In a [more (1)] low ---- [low (2)] voice.
[This (1)] [text (1)] has [foo (1)], or [foo (2)] and [super] foofoo in it.
A nosuper low more [foo (3)] but simple text.
fxx low [more (1)] [foo (1)] text here.
---- [here (1)] [foo (2)] text." ]
}

@test "named resets can specify different reset priorities" {
    run extractMatches --match-count fo+ --global --priority 2 --name foos --reset-name 'fx+' --priority 1 --name foos --match-count '\<\w{4}\>' --priority 1 --name fours --global --reset-name '----' --priority 1 --name fours --count 'low' --global --regexp 'super' --priority 3 --name super --reset-name 'nosuper' --priority 2 --name super <<-'EOF'
A low sexy text.
In a more low ---- low voice.
This text has foo, or foo and super foofoo in it.
A nosuper low more foo but simple text.
fxx low more foo text here.
---- here foo text.
EOF
    [ "$output" = "A [low (1)] [sexy (1)] [text (1)].
In a [more (1)] low ---- [low (2)] voice.
[This (1)] [text (1)] has [foo (1)], or [foo (2)] and [super] foofoo in it.
A nosuper low [more (1)] [foo (3)] but simple text.
fxx [low (3)] [more (2)] [foo (1)] text here.
---- [here (1)] [foo (2)] text." ]
}
