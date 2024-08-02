#!/usr/bin/env bats

export EXTRACTMATCHES_COUNT_BEFORE_TEXT=t
export EXTRACTMATCHES_COUNT_PREFIX=''
export EXTRACTMATCHES_COUNT_SUFFIX=':'

load flash

@test "counts in a line are flashed before the text" {
    run extractMatches --unbuffered --to flash --count fo+ <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously.
EOF
    [ "$output" = "Just some text.
This has ${R}1:foo${N}foo in it.  
All simple lines.
More ${R}2:foo${N}foo here.  
Seriously." ]
}
