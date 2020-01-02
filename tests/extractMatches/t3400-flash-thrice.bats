#!/usr/bin/env bats

load flash
export EXTRACTMATCHES_FLASH_REPEATS=3

@test "single matches in a line are flashed three times" {
    run extractMatches --unbuffered --to flash --regexp fo+ <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously.
EOF
    [ "$output" = "Just some text.
This has ${R}foo${N}foo${R}foo${N}foo${R}foo${N}foo in it.
All simple lines.
More ${R}foo${N}foo${R}foo${N}foo${R}foo${N}foo here.
Seriously." ]
}

@test "two different matches with different single / global are highlighted three times" {
    run extractMatches --unbuffered --to flash --count fo+ --global --count 'x' <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
EOF
    [ "$output" = "Just some se${R}x (1)${N}x (1)${R}x (1)${N}x (1)${R}x (1)${N}xy text.    
This has ${R}foo (1)${N}foo (1)${R}foo (1)${N}foo (1)${R}foo (1)${N}foo, ${R}foo (2)${N}foo (2)${R}foo (2)${N}foo (2)${R}foo (2)${N}foo and ${R}foo (3)${N}foo (3)${R}foo (3)${N}foo (3)${R}foo (3)${N}foo${R}foo (4)${N}foo (4)${R}foo (4)${N}foo (4)${R}foo (4)${N}foo in it.    " ]
}
