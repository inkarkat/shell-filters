#!/usr/bin/env bats

@test "epochs with identical field 3 are summarized" {
    run timestampTally --summarize 3 <<'EOF'
1594133230 irrelevant FOO
1594133231 drivel FOO
1594133232 is FOO
1594133235 written BAR
1594133238 here BAR
1594133239 now BAZ
1594133240 it FOO
1594133250 will FOO
1594133260 still QUUX
1594133261 continue AAA
1594133262 for AAA
1594133264 some AAA
1594133265 more ZAP
1594133267 time ZAP
1594133268 befor AAA
1594133269 coming AAA
1594133300 to FOO
1594133320 an FOO
1594133322 end BAZ
1594133333 here MID
EOF

    [ $status -eq 0 ]
    [ "$output" = "32 FOO
3 BAR
0 BAZ
0 QUUX
4 AAA
2 ZAP
0 MID" ]
}

