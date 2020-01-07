#!/usr/bin/env bats

@test "trailing empty line" {
    run truncate-tail-paragraph <<-'EOF'
One
first
paragraph.

Last
paragraph.

EOF
    [ $status -eq 0 ]
    [ "$output" = "Last
paragraph." ]
}

@test "two trailing empty lines are kept (questionable implementation artifact)" {
    run truncate-tail-paragraph <<-'EOF'
One
first
paragraph.

Last
paragraph.


EOF
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "four trailing empty lines are kept (questionable implementation artifact)" {
    run truncate-tail-paragraph <<-'EOF'
One
first
paragraph.

Last
paragraph.




EOF
    [ $status -eq 0 ]
    [ "$output" = "" ]
}
