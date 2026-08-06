#!/usr/bin/env bats

load fixture

@test "highlighting of plain input" {
    runWithInput '' highlightRelativeAge --palette testing
    assert_output - <<'EOF'
{MINUTES}3 minutes ago {}I was here
{MONTHS}5 months ago{}
{1-9DAYS_OR_WEEK}7 days ago {}is the same as
{1-9DAYS_OR_WEEK}1 week ago{}
Warning:{10+DAYS_OR_WEEKS} (10 days ago){} It finally happened.
{10+DAYS_OR_WEEKS}2 weeks ago {}almost
That happened recently{MINUTES} (1 minute ago){}
EOF
}

@test "highlighting of plain input with date-deletion" {
    runWithInput '' highlightRelativeAge --palette testing --delete-date
    assert_output - <<'EOF'
{MINUTES}I was here{}
{MONTHS}{}
{1-9DAYS_OR_WEEK}is the same as{}
{1-9DAYS_OR_WEEK}{}
{10+DAYS_OR_WEEKS}Warning: It finally happened.{}
{10+DAYS_OR_WEEKS}almost{}
{MINUTES}That happened recently{}
EOF
}

@test "highlighting of colored input" {
    runWithInput '[1m' highlightRelativeAge --palette testing
    assert_output - <<'EOF'
{MINUTES}3 minutes ago {}[1mI was here[0m
{MONTHS}5 months ago[0m{}[1m
{1-9DAYS_OR_WEEK}7 days ago {}is the same as
{1-9DAYS_OR_WEEK}1 week ago{}
[1mWarning:{10+DAYS_OR_WEEKS} (10 days ago){}[1m It finally happened.[0m
{10+DAYS_OR_WEEKS}2 weeks ago {}almost
[1mThat happened recently{MINUTES} (1 minute ago){}[1m[0m
EOF
}

@test "highlighting of colored input with date-deletion" {
    runWithInput '07m' highlightRelativeAge --palette testing --delete-date
    assert_output - <<'EOF'
07m3 minutes ago I was here[0m
07m5 months ago[0m
{1-9DAYS_OR_WEEK}is the same as{}
{1-9DAYS_OR_WEEK}{}
{10+DAYS_OR_WEEKS}07mWarning: It finally happened.[0m{}
{10+DAYS_OR_WEEKS}almost{}
{MINUTES}07mThat happened recently[0m{}
EOF
}
