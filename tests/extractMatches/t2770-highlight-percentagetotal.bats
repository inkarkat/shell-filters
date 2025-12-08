#!/usr/bin/env bats

load fixture

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "percentages against total for a single count" {
    run -0 extractMatches --percentage-total foos 5 --count fo+ --global --name foos <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    assert_output - <<'EOF'
This has [foo (1 = 20%)], [foo (2 = 40%)] and [foo (3 = 60%)][foo (4 = 80%)] in it.
More [foooo (5 = 100%)] and [foo (6 = 120%)] here.
EOF
}

@test "percentages against total for unnamed count via pattern" {
    run -0 extractMatches --percentage-total fo+ 5 --count fo+ --global <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    assert_output - <<'EOF'
This has [foo (1 = 20%)], [foo (2 = 40%)] and [foo (3 = 60%)][foo (4 = 80%)] in it.
More [foooo (5 = 100%)] and [foo (6 = 120%)] here.
EOF
}

@test "percentages against total for three counts from a single match-count" {
    run -0 extractMatches --match-count fo+ --global --name foos --percentage-total foos 5 <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
All more simple text.
And more foo text here.
Or fooo text.
EOF
    assert_output - <<'EOF'
Or some sexy text.
This text has [foo (1 = 20%)], or [foooo (1 = 20%)] and [foo (2 = 40%)][foo (3 = 60%)] in it.
All more simple text.
And more [foo (4 = 80%)] text here.
Or [fooo (1 = 20%)] text.
EOF
}

@test "percentages against total for counts from one name, but not from another name" {
    run -0 extractMatches --percentage-total fours 5 --match-count fo+ --global --name foos --match-count '\<\w{4}\>' --global --name fours <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
All more simple text.
And more foo text here.
Or fooo text.
EOF
    assert_output - <<'EOF'
Or [some (1 = 20%)] [sexy (1 = 20%)] [text (1 = 20%)].
[This (1 = 20%)] [text (2 = 40%)] has [foo (1)], or [foooo (1)] and [foo (2)][foo (3)] in it.
All [more (1 = 20%)] simple [text (3 = 60%)].
And [more (2 = 40%)] [foo (4)] [text (4 = 80%)] [here (1 = 20%)].
Or [fooo (1)] [text (5 = 100%)].
EOF
}

@test "percentages against total for counts from multiple names" {
    run -0 extractMatches --percentage-total fours 5 --percentage-total foos 20 --match-count fo+ --global --name foos --match-count '\<\w{4}\>' --global --name fours <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
All more simple text.
And more foo text here.
Or fooo text.
EOF
    assert_output - <<'EOF'
Or [some (1 = 20%)] [sexy (1 = 20%)] [text (1 = 20%)].
[This (1 = 20%)] [text (2 = 40%)] has [foo (1 = 5.0%)], or [foooo (1 = 5.0%)] and [foo (2 = 10%)][foo (3 = 15%)] in it.
All [more (1 = 20%)] simple [text (3 = 60%)].
And [more (2 = 40%)] [foo (4 = 20%)] [text (4 = 80%)] [here (1 = 20%)].
Or [fooo (1 = 5.0%)] [text (5 = 100%)].
EOF
}

@test "percentages against total for selected match-counts from multiple names" {
    run -0 extractMatches --percentage-total fours-text 5 --percentage-total foos-fooo 50 --match-count fo+ --global --name foos --match-count '\<\w{4}\>' --global --name fours <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
All more simple text.
And more foo text here.
Or fooo text.
EOF
    assert_output - <<'EOF'
Or [some (1)] [sexy (1)] [text (1 = 20%)].
[This (1)] [text (2 = 40%)] has [foo (1)], or [foooo (1 = 2.0%)] and [foo (2)][foo (3)] in it.
All [more (1)] simple [text (3 = 60%)].
And [more (2)] [foo (4)] [text (4 = 80%)] [here (1)].
Or [fooo (1 = 2.0%)] [text (5 = 100%)].
EOF
}

@test "percentages against total for count and match-counts are combined under same name prefix" {
    run -0 extractMatches --percentage-total fo 50 --count fo+ --global --name foos --name foos --match-count '\<\w{4}\>' --global --name fours <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
All more simple text.
And more foooo text here.
Or fooo text.
EOF
    assert_output - <<'EOF'
Or [some (1 = 2.0%)] [sexy (1 = 2.0%)] [text (1 = 2.0%)].
[This (1 = 2.0%)] [text (2 = 4.0%)] has [foo (1 = 2.0%)], or [foooo (2 = 4.0%)] and [foo (3 = 6.0%)][foo (4 = 8.0%)] in it.
All [more (1 = 2.0%)] simple [text (3 = 6.0%)].
And [more (2 = 4.0%)] [foooo (5 = 10%)] [text (4 = 8.0%)] [here (1 = 2.0%)].
Or [fooo (6 = 12%)] [text (5 = 10%)].
EOF
}

@test "mixed percentages for counts from multiple names against totals / counts" {
    run -0 extractMatches --percentage-total fours 500 --name-percentages foos --match-count fo+ --global --name foos --match-count '\<\w{4}\>' --global --name fours <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
All more simple text.
And more foo text here.
Or fooo text.
EOF
    assert_output - <<'EOF'
Or [some (1 = 0.2%)] [sexy (1 = 0.2%)] [text (1 = 0.2%)].
[This (1 = 0.2%)] [text (2 = 0.4%)] has [foo (1 = 100%)], or [foooo (1 = 50%)] and [foo (2 = 67%)][foo (3 = 75%)] in it.
All [more (1 = 0.2%)] simple [text (3 = 0.6%)].
And [more (2 = 0.4%)] [foo (4 = 80%)] [text (4 = 0.8%)] [here (1 = 0.2%)].
Or [fooo (1 = 17%)] [text (5 = 1.0%)].
EOF
}
