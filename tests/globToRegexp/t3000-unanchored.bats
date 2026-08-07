#!/usr/bin/env bats

load fixture

@test "text to unanchored basic regexp" {
    run -0 globToRegexp --unanchored '[Ff]??b*r'
    assert_output '[Ff]..b.*r'
}
