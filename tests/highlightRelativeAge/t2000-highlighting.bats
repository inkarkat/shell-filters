#!/usr/bin/env bats

load fixture

@test "highlighting of plain input" {
    runWithInput '' highlightRelativeAge
    assert_output - <<'EOF'
[38;5;155m3 minutes ago [0mI was here
[38;5;124m5 months ago [0mit broke
Warning:[38;5;132m (10 days ago)[0m It finally happened.
That happened recently[38;5;155m (1 minute ago)[0m
EOF
}

@test "highlighting of plain input with date-deletion" {
    runWithInput '' highlightRelativeAge --delete-date
    assert_output - <<'EOF'
[38;5;155mI was here[0m
[38;5;124mit broke[0m
[38;5;132mWarning: It finally happened.[0m
[38;5;155mThat happened recently[0m
EOF
}

@test "highlighting of colored input" {
    runWithInput '[1m' highlightRelativeAge
    assert_output - <<'EOF'
[38;5;155m3 minutes ago [0m[1mI was here[0m
[38;5;124m5 months ago [0m[1mit broke[0m
[1mWarning:[38;5;132m (10 days ago)[0m[1m It finally happened.[0m
[1mThat happened recently[38;5;155m (1 minute ago)[0m[1m[0m
EOF
}

@test "highlighting of colored input with date-deletion" {
    runWithInput '07m' highlightRelativeAge --delete-date
    assert_output - <<'EOF'
07m3 minutes ago I was here[0m
07m5 months ago it broke[0m
[38;5;132m07mWarning: It finally happened.[0m[0m
[38;5;155m07mThat happened recently[0m[0m
EOF
}
