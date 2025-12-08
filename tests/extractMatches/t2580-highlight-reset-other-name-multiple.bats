#!/usr/bin/env bats

load fixture

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "single counts in a line are reset via name-pattern by another count" {
    run -0 extractMatches --count fo+ --name foos --count '\<\w{4}\>' --name fours --count All --reset-other '/^fo(o|ur)s/'  <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
Just foooo here.
Seriously.
EOF
    assert_output - <<'EOF'
[Just (1)] some text.
[This (2)] has [foo (1)] in it.
[All (1)] simple lines.
[Just (1)] [foooo (1)] here.
Seriously.
EOF
}

@test "two different patterns with prefixed counts are reset by the same other-reset" {
    run -0 extractMatches --count fo+ --global --name prefixed --regexp '\<[Aa]nd\>' --reset-other '/^prefixed-/' --count '\<text\>' --global --name prefixed --count '\<[Oo]r\>' <<-'EOF'
Or some sexy text.
This text has foo, or foo and foofoo in it.
All simple text.
And more foo text here.
Or foo text.
EOF
    assert_output - <<'EOF'
[Or (1)] some sexy [text (1)].
This [text (2)] has [foo (1)], [or (2)] [foo (2)] [and] [foo (1)][foo (2)] in it.
All simple [text (1)].
[And] more [foo (1)] [text (1)] here.
[Or (3)] [foo (2)] [text (2)].
EOF
}

@test "two different counts are reset by other-reset" {
    run -0 extractMatches --count fo+ --global --name foos --count '\<[Aa]nd\>' --reset-other '/^fo(o|ur)s/' --count '\<text\>' --global --name fours --count '\<[Oo]r\>' <<-'EOF'
Or some sexy text.
This text has foo, or foo and foofoo in it.
All simple text.
And more foo text here.
Or foo text.
EOF
    assert_output - <<'EOF'
[Or (1)] some sexy [text (1)].
This [text (2)] has [foo (1)], [or (2)] [foo (2)] [and (1)] [foo (1)][foo (2)] in it.
All simple [text (1)].
[And (2)] more [foo (1)] [text (1)] here.
[Or (3)] [foo (2)] [text (2)].
EOF
}

@test "some match-counts are reset by other-reset" {
    run -0 extractMatches --match-count '\<\w{4}\>' --global --name fours --match-count '\<[Aa]nd\>' --reset-other '/^fours-[st]/' --regexp '\<[Oo]r\>' --reset-other 'fours-fooo' <<-'EOF'
Or some more sexy text.
This text has fooo, or fooo and fooo fooo in it.
All simple text.
And more sexy fooo text here.
Or some fooo text.
EOF
    assert_output - <<'EOF'
[Or] [some (1)] [more (1)] [sexy (1)] [text (1)].
[This (1)] [text (2)] has [fooo (1)], [or] [fooo (1)] [and (1)] [fooo (2)] [fooo (3)] in it.
All simple [text (1)].
[And (1)] [more (2)] [sexy (1)] [fooo (4)] [text (1)] [here (1)].
[Or] [some (1)] [fooo (1)] [text (2)].
EOF
}

@test "count and match-counts are reset by name-pattern" {
    run -0 extractMatches --count fo+ --global --name foos --count '[Oo]r' --reset-other /^fours-[st]/ --reset '[Aa]nd' --reset-other foos-fo+ --match-count '\<\w{4}\>' --global --name fours <<-'EOF'
Or some sexy text.
This text has foo, or foo and foofoo in it.
All more simple text.
And more foooo text here.
Or foooooo text.
EOF
    assert_output - <<'EOF'
[Or (1)] [some (1)] [sexy (1)] [text (1)].
[This (1)] [text (2)] has [foo (1)], [or (2)] [foo (2)] and [foo (1)][foo (2)] in it.
All [more (1)] simple [text (1)].
And [more (2)] [foooo (1)] [text (2)] [here (1)].
[Or (1)] [foooooo (2)] [text (1)].
EOF
}
