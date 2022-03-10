#!/usr/bin/env bats

load sweeper

@test "duplicate interactive sweeping in multiple locations" {
    run collapseDuplicates --unbuffered --as sweep <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
A unique statement.
End of interlude.
This repeats once.
This repeats once.
EOF
    [ "$output" = "This repeats once. [    ]*   ]-*  ] -* ]  -*]   *]  *-] *- ]*-  ]*   ]-*  ]
A unique statement.
End of interlude.
This repeats once. [    ]" ]
}

@test "custom 4-part application-specific sweeper with no common" {
    export COLLAPSEDUPLICATES_SWEEPS='___,A__,_A_,__A,_A_'
    run collapseDuplicates --unbuffered --as sweep <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
EOF
    [ "$output" = "This repeats once. ___A___A___A_A_A___A___A_A_A___A_" ]
}

@test "custom 4-part generic sweeper with 2 common" {
    export SWEEPS='█|  ,█|- ,█|--,█| -,█|--'
    run collapseDuplicates --unbuffered --as sweep <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
EOF
    [ "$output" = "This repeats once. █|  - -- ---- -- ---- --" ]
}
