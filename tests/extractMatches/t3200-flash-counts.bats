#!/usr/bin/env bats

load flash

@test "single counts in a line are flashed" {
    run extractMatches --unbuffered --to flash --count fo+ <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously.
EOF
    [ "$output" = "Just some text.
This has ${R}foo (1)${N}foo in it.    
All simple lines.
More ${R}foo (2)${N}foo here.    
Seriously." ]
}

@test "three different counts with different single / global are highlighted" {
    run extractMatches --unbuffered --to flash --count fo+ --global --count 'ex' --count 'y' --global <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?
EOF
    [ "$output" = "Just some s${R}ex (1)${N}ex${R}y (1)${N}y text.    
This has ${R}foo (1)${N}foo, ${R}foo (2)${N}foo and ${R}foo (3)${N}foo${R}foo (4)${N}foo in it.    
All simple lines.
More ${R}foo (5)${N}foo here.    
Seriousl${R}y (2)${N}y, wh${R}y (3)${N}y?    " ]
}
