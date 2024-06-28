#!/usr/bin/env bats

load fixture

@test "ANSI color sequences" {
    runWithInput $'1 [1m3333[0m [33m444444[0m ([34m55555[0m max) [33m66666666[0m\n[34m1000[0m\n[33m100000[0m\n[34m 1000000[0m\n[33m10000000 [0m\n[34m100000000\n1000000000[0m' humanunits
    [ $status -eq 0 ]
    [ "$output" = "1 [1m3.3Ki[0m [33m435Ki[0m ([34m55Ki[0m max) [33m64Mi[0m
[34m1000[0m
[33m98Ki[0m
[34m 977Ki[0m
[33m9.6Mi [0m
[34m96Mi
954Mi[0m" ]
}
