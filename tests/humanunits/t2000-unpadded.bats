#!/usr/bin/env bats

load fixture

@test "multi-number multi-line output to two-letter IEC" {
    run -0 humanunits <<<$'1 3333 [444444] (55555 max) 66666666 7777777mo.\n1000\n[100000]\n1000000\n[10000000\n100000000]'
    assert_output - <<'EOF'
1 3.3Ki [435Ki] (55Ki max) 64Mi 7777777mo.
1000
[98Ki]
977Ki
[9.6Mi
96Mi]
EOF
}

@test "multi-number multi-line output to one-letter SI" {
    run -0 humanunits --to si <<<$'1 3333 [444444] (55555 max) 66666666 7777777mo.\n1000\n[100000]\n1000000\n[10000000\n100000000]'
    assert_output - <<'EOF'
1 3.4K [445K] (56K max) 67M 7777777mo.
1.0K
[100K]
1.0M
[10M
100M]
EOF
}
