#!/usr/bin/env bats

load fixture

@test "padded multi-number multi-line output to two-letter IEC" {
    runWithInput $'1 3333  444444 (  55555 max)  66666666\n     1000\n   100000\n  1000000\n 10000000\n100000000' humanunits
    [ $status -eq 0 ]
    [ "$output" = "1 3.3Ki   435Ki (   55Ki max)      64Mi
     1000
     98Ki
    977Ki
 9.6Mi
96Mi" ]
}

@test "padded multi-number multi-line output to one-letter SI" {
    runWithInput $'1 3333  444444 (  55555 max)  66666666\n     1000\n   100000\n  1000000\n 10000000\n100000000' humanunits --to si
    [ $status -eq 0 ]
    [ "$output" = "1 3.4K    445K (    56K max)       67M
     1.0K
     100K
     1.0M
 10M
100M" ]
}
