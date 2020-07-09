#!/usr/bin/env bats

input="1594133230 irrelevant FOO 1 random X
1594133231 drivel FOO 1 stuff X
1594133232 is FOO 2 can X
1594133235 written BAR 2 be X
1594133238 here BAR 2 found X
1594133239 now BAZ 2 here Y
1594133240 it FOO 3 up Y
1594133250 will FOO 3 until Y
1594133260 come QUUX 3 this Z
1594133300 to FOO 4 ends Z
1594133320 an FOO 4 right Z
1594133322 end BAZ 4 there Z"

@test "epochs with identical uppercase match are summarized" {
    run timestampTally --summarize '[[:upper:]]+' <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "32 FOO
3 BAR
0 BAZ
0 QUUX" ]
}

@test "epochs with identical uppercase match are summarized, with a custom single entry duration of 1 second" {
    run timestampTally --single-entry-duration 1 --summarize '[[:upper:]]+' <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "32 FOO
3 BAR
2 BAZ
1 QUUX" ]
}

@test "epochs with identical uppercase match are summarized with kept start timestamp" {
    run timestampTally --summarize '[[:upper:]]+' --keep-timestamp start <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1594133230 32 FOO
1594133235 3 BAR
1594133239 0 BAZ
1594133260 0 QUUX" ]
}

@test "epochs with identical uppercase match are summarized with kept end timestamp" {
    run timestampTally --summarize '[[:upper:]]+' --keep-timestamp end <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1594133320 32 FOO
1594133238 3 BAR
1594133322 0 BAZ
1594133260 0 QUUX" ]
}

@test "epochs with identical uppercase match are summarized with kept both concatenated timestamps" {
    run timestampTally --summarize '[[:upper:]]+' --keep-timestamp both-concatenated <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1594133230 1594133320 32 FOO
1594133235 1594133238 3 BAR
1594133239 1594133322 0 BAZ
1594133260 1594133260 0 QUUX" ]
}
