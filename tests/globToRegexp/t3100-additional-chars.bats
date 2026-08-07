#!/usr/bin/env bats

load fixture

@test "additional slash is escaped to basic regexp" {
    run -0 globToRegexp --additional-chars / 'foo/bar\ @re h^r^'
    assert_output '^foo\/bar\\ @re h\^r\^$'
}

@test "additional # and % are escaped to basic regexp" {
    run -0 globToRegexp --additional-chars '#%' 'foo### @nd %bar% @re h^r^'
    assert_output '^foo\#\#\# @nd \%bar\% @re h\^r\^$'
}
