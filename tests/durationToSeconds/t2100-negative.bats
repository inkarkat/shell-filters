#!/usr/bin/env bats

load fixture

@test "negative durations are rejected by default" {
    run -1 durationToSeconds -- '-1h 15m 30s'
    assert_output ''
}

@test "negative durations are converted when negative is accepted" {
    DURATIONTOSECONDS_ACCEPT_NEGATIVE=t run -0 durationToSeconds -- '-1h 15m 30s'
    assert_output '-4530'
}

@test "negative durations are converted when sign is accepted" {
    DURATIONTOSECONDS_ACCEPT_SIGN=t run -0 durationToSeconds -- '-1h 15m 30s'
    assert_output '-4530'
}
