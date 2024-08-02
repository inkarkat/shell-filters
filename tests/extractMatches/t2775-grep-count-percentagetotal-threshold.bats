#!/usr/bin/env bats

@test "default tallies all percentages for counts from a single match-count" {
    run extractMatches --grep-count --match-count fo+ --global --name foos --percentage-total foos 50 <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
Let's foo more for foo and foo.
Introduce fooo here.
And more foo foo text here.
Or fooo text with fooo.
EOF

    [ "$output" = "fo: 1 = 2.0%
foo: 8 = 16%
fooo: 3 = 6.0%
foooo: 1 = 2.0%" ]
}

@test "tally with percentage threshold for counts from a single match-count omits lower ones" {
    run extractMatches --grep-count --match-count fo+ --global --name foos --name-percentage-threshold 6 --percentage-total foos 50 <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
Let's foo more for foo and foo.
Introduce fooo here.
And more foo foo text here.
Or fooo text with fooo.
EOF

    [ "$output" = "foo: 8 = 16%
fooo: 3 = 6.0%" ]
}

@test "tally with same percentage threshold for counts from multiple names" {
    run extractMatches --grep-count --name-percentage-threshold 46 --percentage-total fours 50 --percentage-total foos 5 --percentage-total caps 4 \
	--match-count fo+ --global --name foos --match-count '\<\w{4}\>' --global --name fours --match-count '[A-Z]{2,}' --global --name caps <<-'EOF'
LISTEN Or some sexy text IMPORTANT.
This text has foo, or foooo and foofoo in it.
LISTEN All more simple text.
And more foo text here.
LISTEN Or fooo text.
EOF

    [ "$output" = "foo: 4 = 80%
LISTEN: 3 = 75%" ]
}

@test "tally with different percentage thresholds for counts from multiple names" {
    run extractMatches --grep-count --percentage-total fours 50 --name-percentage-threshold 22 --percentage-total foos 5 --name-percentage-threshold 66 --percentage-total caps 4 \
	--match-count fo+ --global --name foos --match-count '\<\w{4}\>' --global --name fours --match-count '[A-Z]{2,}' --global --name caps <<-'EOF'
LISTEN Or some sexy text IMPORTANT.
This text has foo, or foooo and foofoo in it.
LISTEN All more simple text.
And more foo text here.
LISTEN Or fooo text.
EOF

    [ "$output" = "foo: 4 = 80%
This: 1 = 2.0%
here: 1 = 2.0%
more: 2 = 4.0%
sexy: 1 = 2.0%
some: 1 = 2.0%
text: 5 = 10%
LISTEN: 3 = 75%" ]
}
