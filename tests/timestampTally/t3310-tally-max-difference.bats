#!/usr/bin/env bats

input="foo 2020-07-04T16:07:23,001 some
foo 2020-07-04T16:07:23,002 text
foo 2020-07-04T16:07:25,001 that
foo 2020-07-04T16:08:22,999 nobody
foo 2020-07-04T16:08:23,001 reads
foo 2020-07-04T16:09:23,001 anyway
foo 2020-07-04T16:10:23,002 too
bar 2020-07-04T16:08:23,003 dense
bar 2020-07-04T16:09:23,000 and
bar 2020-07-04T16:10:25,004 confusing
bar 2020-07-04T16:11:35,000 for
bar 2020-07-04T16:12:35,000 most
bar 2020-07-04T16:12:56,000 people"

@test "ISO 8601 timestamps in field 2 with identical field 1 within 1 minute are condensed to the first occurrence" {
    run timestampTally --timestamp-field 2 --max-difference 1m --single-entry-duration 7 --tally 1 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "foo 120 some
foo 7 too
bar 59.997 dense
bar 7 confusing
bar 81 for" ]
}

@test "ISO 8601 timestamps in field 2 with identical field 1 within 1 minute are condensed to the first occurrence with kept start timestamp" {
    run timestampTally --timestamp-field 2 --keep-timestamp start --max-difference 1m --single-entry-duration 7 --tally 1 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "foo 2020-07-04T16:07:23,001 120 some
foo 2020-07-04T16:10:23,002 7 too
bar 2020-07-04T16:08:23,003 59.997 dense
bar 2020-07-04T16:10:25,004 7 confusing
bar 2020-07-04T16:11:35,000 81 for" ]
}

@test "ISO 8601 timestamps in field 2 with identical field 1 within 1 minute are condensed to the first occurrence with kept end timestamp" {
    run timestampTally --timestamp-field 2 --keep-timestamp end --max-difference 1m --single-entry-duration 7 --tally 1 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "foo 2020-07-04T16:09:23,001 120 anyway
foo 2020-07-04T16:10:23,002 7 too
bar 2020-07-04T16:09:23,000 59.997 and
bar 2020-07-04T16:10:25,004 7 confusing
bar 2020-07-04T16:12:56,000 81 people" ]
}

@test "ISO 8601 timestamps in field 2 with identical field 1 within 1 minute are condensed to the first occurrence with kept both concatenated timestamps" {
    run timestampTally --timestamp-field 2 --keep-timestamp both-concatenated --max-difference 1m --single-entry-duration 7 --tally 1 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "foo 2020-07-04T16:07:23,001 2020-07-04T16:09:23,001 120 some
foo 2020-07-04T16:10:23,002 2020-07-04T16:10:23,002 7 too
bar 2020-07-04T16:08:23,003 2020-07-04T16:09:23,000 59.997 dense
bar 2020-07-04T16:10:25,004 2020-07-04T16:10:25,004 7 confusing
bar 2020-07-04T16:11:35,000 2020-07-04T16:12:56,000 81 for" ]
}

@test "ISO 8601 timestamps in field 2 with identical field 1 within 1 minute are condensed to the first occurrence with kept separate start and end timestamps" {
    run timestampTally --timestamp-field 2 --keep-timestamp both-separate --max-difference 1m --single-entry-duration 7 --tally 1 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "foo 2020-07-04T16:07:23,001 120 some
foo 2020-07-04T16:09:23,001 120 anyway
foo 2020-07-04T16:10:23,002 7 too
bar 2020-07-04T16:08:23,003 59.997 dense
bar 2020-07-04T16:09:23,000 59.997 and
bar 2020-07-04T16:10:25,004 7 confusing
bar 2020-07-04T16:11:35,000 81 for
bar 2020-07-04T16:12:56,000 81 people" ]
}

@test "ISO 8601 timestamps in field 2 with identical field 1 within 1 minute and a maximum duration of 80 seconds condensed to the first occurrence with kept separate start and end timestamps" {
    run timestampTally --timestamp-field 2 --keep-timestamp both-separate --max-difference 1m --max-record-duration 80 --tally 1 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "foo 2020-07-04T16:07:23,001 60 some
foo 2020-07-04T16:08:23,001 60 reads
foo 2020-07-04T16:09:23,001 0 anyway
foo 2020-07-04T16:10:23,002 0 too
bar 2020-07-04T16:08:23,003 59.997 dense
bar 2020-07-04T16:09:23,000 59.997 and
bar 2020-07-04T16:10:25,004 0 confusing
bar 2020-07-04T16:11:35,000 60 for
bar 2020-07-04T16:12:35,000 60 most
bar 2020-07-04T16:12:56,000 0 people" ]
}

@test "ISO 8601 timestamps in field 2 with identical field 1 within 1 minute and a maximum length of 2 are condensed to the first occurrence with kept separate start and end timestamps" {
    run timestampTally --timestamp-field 2 --keep-timestamp both-separate --max-difference 1m --max-record-length 2 --tally 1 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "foo 2020-07-04T16:07:23,001 0.001 some
foo 2020-07-04T16:07:23,002 0.001 text
foo 2020-07-04T16:07:25,001 57.998 that
foo 2020-07-04T16:08:22,999 57.998 nobody
foo 2020-07-04T16:08:23,001 60 reads
foo 2020-07-04T16:09:23,001 60 anyway
foo 2020-07-04T16:10:23,002 0 too
bar 2020-07-04T16:08:23,003 59.997 dense
bar 2020-07-04T16:09:23,000 59.997 and
bar 2020-07-04T16:10:25,004 0 confusing
bar 2020-07-04T16:11:35,000 60 for
bar 2020-07-04T16:12:35,000 60 most
bar 2020-07-04T16:12:56,000 0 people" ]
}
