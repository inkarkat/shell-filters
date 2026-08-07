#!/usr/bin/env bats

load fixture

@test "empty input to extended regexp" {
    run -0 globToRegexp --extended-regexp ''
    assert_output '^$'
}

@test "literal text to extended regexp" {
    run -0 globToRegexp --extended-regexp 'foo bar'
    assert_output '^foo bar$'
}

@test "star wildcard is converted to .* extended regexp" {
    run -0 globToRegexp --extended-regexp 'foo*bar'
    assert_output '^foo.*bar$'
}

@test "question mark wildcard is converted to . extended regexp" {
    run -0 globToRegexp --extended-regexp 'f??bar'
    assert_output '^f..bar$'
}

@test "character classes are preserved to extended regexp" {
    run -0 globToRegexp --extended-regexp 'f[aeiou][aeiou]ba[^aeiou]'
    assert_output '^f[aeiou][aeiou]ba[^aeiou]$'
}

@test "negated character class has ! converted to ^ extended regexp" {
    run -0 globToRegexp --extended-regexp 'f[!aeiou]bar'
    assert_output '^f[^aeiou]bar$'
}

@test "character class including [ to extended regexp" {
    run -0 globToRegexp --extended-regexp 'f[[]bar'
    assert_output '^f[[]bar$'
}

@test "backslash is escaped to extended regexp" {
    run -0 globToRegexp --extended-regexp 'f\\b\r'
	assert_output '^f\\\\b\\r$'
}

@test "more special characters are escaped to extended regexp" {
    run -0 globToRegexp --extended-regexp 'f$^*+?.()|{}bar'
	assert_output '^f\$\^.*\+.\.\(\)\|\{\}bar$'
}
