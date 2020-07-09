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

@test "epochs with identical uppercase match are condensed to the first occurrence and summarized" {
    run timestampTally --summarize '[[:upper:]]+' <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "32 FOO
3 BAR
0 BAZ
0 QUUX" ]
}

@test "epochs with identical uppercase match are condensed to the first occurrence and summarized, with a custom single entry duration of 1 second" {
    run timestampTally --single-entry-duration 1 --summarize '[[:upper:]]+' <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "32 FOO
3 BAR
2 BAZ
1 QUUX" ]
}
