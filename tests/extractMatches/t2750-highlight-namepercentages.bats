#!/usr/bin/env bats

load fixture

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "percentages for a single count" {
    run -0 extractMatches --name-percentages foos --count fo+ --global --name foos <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    assert_output - <<'EOF'
This has [foo (1 = 100%)], [foo (2 = 100%)] and [foo (3 = 100%)][foo (4 = 100%)] in it.
More [foooo (5 = 100%)] and [foo (6 = 100%)] here.
EOF
}

@test "percentages for unnamed count via pattern" {
    run -0 extractMatches --name-percentages fo+ --count fo+ --global <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    assert_output - <<'EOF'
This has [foo (1 = 100%)], [foo (2 = 100%)] and [foo (3 = 100%)][foo (4 = 100%)] in it.
More [foooo (5 = 100%)] and [foo (6 = 100%)] here.
EOF
}

@test "percentages for three counts from a single match-count" {
    run -0 extractMatches --match-count fo+ --global --name foos --name-percentages foos <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
All more simple text.
And more foo text here.
Or fooo text.
EOF
    assert_output - <<'EOF'
Or some sexy text.
This text has [foo (1 = 100%)], or [foooo (1 = 50%)] and [foo (2 = 67%)][foo (3 = 75%)] in it.
All more simple text.
And more [foo (4 = 80%)] text here.
Or [fooo (1 = 17%)] text.
EOF
}

@test "percentages for counts from one name, but not from another name" {
    run -0 extractMatches --name-percentages fours --match-count fo+ --global --name foos --match-count '\<\w{4}\>' --global --name fours <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
All more simple text.
And more foo text here.
Or fooo text.
EOF
    assert_output - <<'EOF'
Or [some (1 = 100%)] [sexy (1 = 50%)] [text (1 = 33%)].
[This (1 = 25%)] [text (2 = 40%)] has [foo (1)], or [foooo (1)] and [foo (2)][foo (3)] in it.
All [more (1 = 17%)] simple [text (3 = 43%)].
And [more (2 = 25%)] [foo (4)] [text (4 = 44%)] [here (1 = 10%)].
Or [fooo (1)] [text (5 = 45%)].
EOF
}

@test "percentages for counts from multiple names" {
    run -0 extractMatches --name-percentages fours --name-percentages foos --match-count fo+ --global --name foos --match-count '\<\w{4}\>' --global --name fours <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
All more simple text.
And more foo text here.
Or fooo text.
EOF
    assert_output - <<'EOF'
Or [some (1 = 100%)] [sexy (1 = 50%)] [text (1 = 33%)].
[This (1 = 25%)] [text (2 = 40%)] has [foo (1 = 100%)], or [foooo (1 = 50%)] and [foo (2 = 67%)][foo (3 = 75%)] in it.
All [more (1 = 17%)] simple [text (3 = 43%)].
And [more (2 = 25%)] [foo (4 = 80%)] [text (4 = 44%)] [here (1 = 10%)].
Or [fooo (1 = 17%)] [text (5 = 45%)].
EOF
}

@test "percentages for selected match-counts from multiple names" {
    run -0 extractMatches --name-percentages fours-text --name-percentages foos-fooo --match-count fo+ --global --name foos --match-count '\<\w{4}\>' --global --name fours <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
All more simple text.
And more foo text here.
Or fooo text.
EOF
    assert_output - <<'EOF'
Or [some (1)] [sexy (1)] [text (1 = 100%)].
[This (1)] [text (2 = 100%)] has [foo (1)], or [foooo (1 = 100%)] and [foo (2)][foo (3)] in it.
All [more (1)] simple [text (3 = 100%)].
And [more (2)] [foo (4)] [text (4 = 100%)] [here (1)].
Or [fooo (1 = 50%)] [text (5 = 100%)].
EOF
}

@test "percentages for count and match-counts are combined under same name prefix" {
    run -0 extractMatches --name-percentages fo --count fo+ --global --name foos --name foos --match-count '\<\w{4}\>' --global --name fours <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
All more simple text.
And more foooo text here.
Or fooo text.
EOF
    assert_output - <<'EOF'
Or [some (1 = 100%)] [sexy (1 = 50%)] [text (1 = 33%)].
[This (1 = 25%)] [text (2 = 40%)] has [foo (1 = 17%)], or [foooo (2 = 29%)] and [foo (3 = 38%)][foo (4 = 44%)] in it.
All [more (1 = 10%)] simple [text (3 = 27%)].
And [more (2 = 17%)] [foooo (5 = 38%)] [text (4 = 29%)] [here (1 = 6.7%)].
Or [fooo (6 = 38%)] [text (5 = 29%)].
EOF
}

@test "percentages for count and match-counts with reset are combined" {
    run -0 extractMatches --name-percentages fo --count fo+ --global --name foos --reset-name '[Aa]nd' --name foos --match-count '\<\w{4}\>' --global --name fours --reset-name '[Oo]r' --name fours <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
All more simple text.
And more foooo text here.
Or fooo text.
EOF
    assert_output - <<'EOF'
Or [some (1 = 100%)] [sexy (1 = 50%)] [text (1 = 33%)].
[This (1 = 25%)] [text (2 = 40%)] has [foo (1 = 17%)], or [foooo (2 = 100%)] and [foo (1 = 100%)][foo (2 = 100%)] in it.
All [more (1 = 33%)] simple [text (1 = 25%)].
And [more (2 = 67%)] [foooo (1 = 25%)] [text (2 = 40%)] [here (1 = 17%)].
Or [fooo (2 = 100%)] [text (1 = 33%)].
EOF
}
