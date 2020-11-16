#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "default shows all percentages for counts from a single match-count" {
    run extractMatches --match-count fo+ --global --name foos --name-percentages foos <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
Let's foo more for foo and foo.
Introduce fooo here.
And more foo foo text here.
Or fooo text with fooo.
EOF

    [ "$output" = "Or some sexy text.
This text has [foo (1 = 100%)], or [foooo (1 = 50%)] and [foo (2 = 67%)][foo (3 = 75%)] in it.
Let's [foo (4 = 80%)] more [fo (1 = 17%)]r [foo (5 = 71%)] and [foo (6 = 75%)].
Introduce [fooo (1 = 11%)] here.
And more [foo (7 = 70%)] [foo (8 = 73%)] text here.
Or [fooo (2 = 17%)] text with [fooo (3 = 23%)]." ]
}

@test "percentage threshold for counts from a single match-count omits lower ones" {
    run extractMatches --match-count fo+ --global --name foos --name-percentage-threshold 16 --name-percentages foos <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
Let's foo more for foo and foo.
Introduce fooo here.
And more foo foo text here.
Or fooo text with fooo.
EOF

    [ "$output" = "Or some sexy text.
This text has [foo (1 = 100%)], or [foooo (1 = 50%)] and [foo (2 = 67%)][foo (3 = 75%)] in it.
Let's [foo (4 = 80%)] more [fo (1 = 17%)]r [foo (5 = 71%)] and [foo (6 = 75%)].
Introduce fooo here.
And more [foo (7 = 70%)] [foo (8 = 73%)] text here.
Or [fooo (2 = 17%)] text with [fooo (3 = 23%)]." ]
}

@test "same percentage threshold for counts from multiple names" {
    run extractMatches --name-percentage-threshold 40 --name-percentages fours --name-percentages foos --name-percentages caps \
	--match-count fo+ --global --name foos --match-count '\<\w{4}\>' --global --name fours --match-count '[A-Z]{2,}' --global --name caps <<-'EOF'
LISTEN Or some sexy text IMPORTANT.
This text has foo, or foooo and foofoo in it.
LISTEN All more simple text.
And more foo text here.
LISTEN Or fooo text.
EOF

    [ "$output" = "[LISTEN (1 = 100%)] Or [some (1 = 100%)] [sexy (1 = 50%)] text [IMPORTANT (1 = 50%)].
This [text (2 = 40%)] has [foo (1 = 100%)], or [foooo (1 = 50%)] and [foo (2 = 67%)][foo (3 = 75%)] in it.
[LISTEN (2 = 67%)] All more simple [text (3 = 43%)].
And more [foo (4 = 80%)] [text (4 = 44%)] here.
[LISTEN (3 = 75%)] Or fooo [text (5 = 45%)]." ]
}

@test "different percentage thresholds for counts from multiple names" {
    run extractMatches --name-percentages fours --name-percentage-threshold 40 --name-percentages foos --name-percentage-threshold 70 --name-percentages caps \
	--match-count fo+ --global --name foos --match-count '\<\w{4}\>' --global --name fours --match-count '[A-Z]{2,}' --global --name caps <<-'EOF'
LISTEN Or some sexy text IMPORTANT.
This text has foo, or foooo and foofoo in it.
LISTEN All more simple text.
And more foo text here.
LISTEN Or fooo text.
EOF

    [ "$output" = "[LISTEN (1 = 100%)] Or [some (1 = 100%)] [sexy (1 = 50%)] [text (1 = 33%)] IMPORTANT.
[This (1 = 25%)] [text (2 = 40%)] has [foo (1 = 100%)], or [foooo (1 = 50%)] and [foo (2 = 67%)][foo (3 = 75%)] in it.
LISTEN All [more (1 = 17%)] simple [text (3 = 43%)].
And [more (2 = 25%)] [foo (4 = 80%)] [text (4 = 44%)] [here (1 = 10%)].
[LISTEN (3 = 75%)] Or fooo [text (5 = 45%)]." ]
}
