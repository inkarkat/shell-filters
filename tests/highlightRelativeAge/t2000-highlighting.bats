#!/usr/bin/env bats

load fixture

@test "highlighting of plain input" {
    runWithInput '' highlightRelativeAge --palette testing
    assert_output - <<'EOF'
{MINUTES}3 minutes ago {}I was here
{MONTHS}5 months ago{}
Warning:{10+DAYS} (10 days ago){} It finally happened.
That happened recently{MINUTES} (1 minute ago){}
EOF
}

@test "highlighting of plain input with date-deletion" {
    runWithInput '' highlightRelativeAge --palette testing --delete-date
    assert_output - <<'EOF'
{MINUTES}I was here{}
{MONTHS}{}
{10+DAYS}Warning: It finally happened.{}
{MINUTES}That happened recently{}
EOF
}

@test "highlighting of colored input" {
    runWithInput '[1m' highlightRelativeAge --palette testing
    assert_output - <<'EOF'
{MINUTES}3 minutes ago {}[1mI was here[0m
{MONTHS}5 months ago[0m{}[1m
[1mWarning:{10+DAYS} (10 days ago){}[1m It finally happened.[0m
[1mThat happened recently{MINUTES} (1 minute ago){}[1m[0m
EOF
}

@test "highlighting of colored input with date-deletion" {
    runWithInput '07m' highlightRelativeAge --palette testing --delete-date
    assert_output - <<'EOF'
07m3 minutes ago I was here[0m
07m5 months ago[0m
{10+DAYS}07mWarning: It finally happened.[0m{}
{MINUTES}07mThat happened recently[0m{}
EOF
}
