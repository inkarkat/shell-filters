#!/usr/bin/env bats

load flash

@test "single match-counts in a line are flashed" {
    run extractMatches --unbuffered --to flash --match-count fo+ <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously.
EOF
    [ "$output" = "Just some text.
This has ${R}foo (1)${N}foo in it.    
All simple lines.
More ${R}foooo (1)${N}foooo here.    
Seriously." ]
}

@test "two different match-counts in a line are flashed" {
    run extractMatches --unbuffered --to flash --match-count fo+ --global --match-count '\<\w{4}\>' --global <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple text.
More foo here.
Seriously, why?
EOF
    [ "$output" = "${R}Just (1)${N}Just ${R}some (1)${N}some ${R}sexy (1)${N}sexy ${R}text (1)${N}text.    
${R}This (1)${N}This has ${R}foo (1)${N}foo, ${R}foo (2)${N}foo and ${R}foo (3)${N}foo${R}foo (4)${N}foo in it.    
All simple ${R}text (2)${N}text.    
${R}More (1)${N}More ${R}foo (5)${N}foo ${R}here (1)${N}here.    
Seriously, why?" ]
}
