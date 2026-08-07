#!/usr/bin/env bats

load fixture

@test "empty input to basic regexp" {
    run -0 globToRegexp ''
    assert_output '^$'
}

@test "literal text to basic regexp" {
    run -0 globToRegexp 'foo bar'
    assert_output '^foo bar$'
}

@test "star wildcard is converted to .* basic regexp" {
    run -0 globToRegexp 'foo*bar'
    assert_output '^foo.*bar$'
}

@test "question mark wildcard is converted to . basic regexp" {
    run -0 globToRegexp 'f??bar'
    assert_output '^f..bar$'
}

@test "character classes are preserved to basic regexp" {
    run -0 globToRegexp 'f[aeiou][aeiou]ba[^aeiou]'
    assert_output '^f[aeiou][aeiou]ba[^aeiou]$'
}

@test "negated character class has ! converted to ^ basic regexp" {
    run -0 globToRegexp 'f[!aeiou]bar'
    assert_output '^f[^aeiou]bar$'
}

@test "character class including [ to basic regexp" {
    run -0 globToRegexp 'f[[]bar'
    assert_output '^f[[]bar$'
}

@test "backslash is escaped to basic regexp" {
    run -0 globToRegexp 'f\\b\r'
	assert_output '^f\\\\b\\r$'
}

@test "special characters are escaped to basic regexp" {
    run -0 globToRegexp 'f$^*+?.()|{}bar'
	assert_output '^f\$\^.*+.\.()|{}bar$'
}
