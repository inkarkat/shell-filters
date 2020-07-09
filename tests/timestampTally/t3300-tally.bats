#!/usr/bin/env bats

input="1594133230 irrelevant FOO 1 random X
1594133231 drivel FOO 1 stuff X
1594133232 is FOO 2 can X
1594133235 written BAR 2 be X
1594133238 here BAR 2 found X
1594133239 now BAZ 2 here Y
1594133240 it FOO 3 up Y
1594133250 will FOO 3 until Y
1594133260 end QUUX 3 this Z"

@test "epochs with identical uppercase match are condensed to the first occurrence" {
    run timestampTally --tally '[[:upper:]]+' <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "2 irrelevant FOO 1 random X
3 written BAR 2 be X
0 now BAZ 2 here Y
10 it FOO 3 up Y
0 end QUUX 3 this Z" ]
}

@test "epochs with identical field 3 are condensed to the first occurrence" {
    run timestampTally --tally 3 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "2 irrelevant FOO 1 random X
3 written BAR 2 be X
0 now BAZ 2 here Y
10 it FOO 3 up Y
0 end QUUX 3 this Z" ]
}

@test "epochs with identical fields 3 and 4 are condensed to the first occurrence" {
    run timestampTally --tally 3-4 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1 irrelevant FOO 1 random X
0 is FOO 2 can X
3 written BAR 2 be X
0 now BAZ 2 here Y
10 it FOO 3 up Y
0 end QUUX 3 this Z" ]
}

@test "epochs with identical field 6 are condensed to the first occurrence" {
    run timestampTally --tally 6 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "8 irrelevant FOO 1 random X
11 now BAZ 2 here Y
0 end QUUX 3 this Z" ]
}

@test "epochs with identical fields 3 and 6 are condensed to the first occurrence" {
    run timestampTally --tally 3,6 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "2 irrelevant FOO 1 random X
3 written BAR 2 be X
0 now BAZ 2 here Y
10 it FOO 3 up Y
0 end QUUX 3 this Z" ]
}

@test "epochs with identical fields 3-4 and 6 are condensed to the first occurrence" {
    run timestampTally --tally 3-4,6 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1 irrelevant FOO 1 random X
0 is FOO 2 can X
3 written BAR 2 be X
0 now BAZ 2 here Y
10 it FOO 3 up Y
0 end QUUX 3 this Z" ]
}

@test "epochs with identical fields 3, 4 and 6 are condensed to the first occurrence" {
    run timestampTally --tally 3,4,6 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1 irrelevant FOO 1 random X
0 is FOO 2 can X
3 written BAR 2 be X
0 now BAZ 2 here Y
10 it FOO 3 up Y
0 end QUUX 3 this Z" ]
}
