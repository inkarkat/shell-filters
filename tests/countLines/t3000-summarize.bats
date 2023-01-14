#!/usr/bin/env bats

load fixture

@test "summarize" {
    runWithCannedInput countLines --summarize stuff
    [ $status -eq 0 ]
    [ "$output" = "(1) foo
(2) bar
(3) baz
(4) hihi
(5) 
(6) something
(7) is
(8) wrong
(9) here
(10) 
(11) nothing
(12) for
(13) me
(13 stuffs in total)" ]
}

@test "summarize singular" {
    runWithInput foo countLines --summarize entry,entries
    [ $status -eq 0 ]
    [ "$output" = "(1) foo
(1 entry in total)" ]
}

@test "summarize plural" {
    runWithInput $'foo\nbar' countLines --summarize entry,entries
    [ $status -eq 0 ]
    [ "$output" = "(1) foo
(2) bar
(2 entries in total)" ]
}

@test "summarize nothing" {
    runWithInput '' countLines --summarize entry,entries
    [ $status -eq 0 ]
    [ "$output" = "(0 entries in total)" ]
}

@test "summary only" {
    runWithCannedInput countLines --summarize stuff --summary-only
    [ $status -eq 0 ]
    [ "$output" = "foo
bar
baz
hihi

something
is
wrong
here

nothing
for
me
(13 stuffs in total)" ]
}
