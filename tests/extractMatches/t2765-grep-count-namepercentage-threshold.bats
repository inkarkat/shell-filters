#!/usr/bin/env bats

@test "default tallies all percentages for counts from a single match-count" {
    run extractMatches --grep-count --match-count fo+ --global --name foos --name-percentages foos <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
Let's foo more for foo and foo.
Introduce fooo here.
And more foo foo text here.
Or fooo text with fooo.
EOF

    [ "$output" = "fo: 1 = 7.7%
foo: 8 = 62%
fooo: 3 = 23%
foooo: 1 = 7.7%" ]
}

@test "tally with percentage threshold for counts from a single match-count omits lower ones" {
    run extractMatches --grep-count --match-count fo+ --global --name foos --name-percentage-threshold 8 --name-percentages foos <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
Let's foo more for foo and foo.
Introduce fooo here.
And more foo foo text here.
Or fooo text with fooo.
EOF

    [ "$output" = "foo: 8 = 62%
fooo: 3 = 23%" ]
}

@test "tally with same percentage threshold for counts from multiple names" {
    run extractMatches --grep-count --name-percentage-threshold 46 --name-percentages fours --name-percentages foos --name-percentages caps \
	--match-count fo+ --global --name foos --match-count '\<\w{4}\>' --global --name fours --match-count '[A-Z]{2,}' --global --name caps <<-'EOF'
LISTEN Or some sexy text IMPORTANT.
This text has foo, or foooo and foofoo in it.
LISTEN All more simple text.
And more foo text here.
LISTEN Or fooo text.
EOF

    [ "$output" = "foo: 4 = 67%
LISTEN: 3 = 75%" ]
}

@test "tally with different percentage thresholds for counts from multiple names" {
    run extractMatches --grep-count --name-percentages fours --name-percentage-threshold 18 --name-percentages foos --name-percentage-threshold 50 --name-percentages caps \
	--match-count fo+ --global --name foos --match-count '\<\w{4}\>' --global --name fours --match-count '[A-Z]{2,}' --global --name caps <<-'EOF'
LISTEN Or some sexy text IMPORTANT.
This text has foo, or foooo and foofoo in it.
LISTEN All more simple text.
And more foo text here.
LISTEN Or fooo text.
EOF

    [ "$output" = "foo: 4 = 67%
This: 1 = 9.1%
here: 1 = 9.1%
more: 2 = 18%
sexy: 1 = 9.1%
some: 1 = 9.1%
text: 5 = 45%
LISTEN: 3 = 75%" ]
}
