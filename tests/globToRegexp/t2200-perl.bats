#!/usr/bin/env bats

load fixture

@test "empty input to Perl regexp" {
    run -0 globToRegexp --perl-regexp ''
    assert_output '^$'
}

@test "literal text to Perl regexp" {
    run -0 globToRegexp --perl-regexp 'foo bar'
    assert_output '^\Qfoo bar\E$'
}

@test "star wildcard is converted to .* Perl regexp" {
    run -0 globToRegexp --perl-regexp 'foo*bar'
    assert_output '^\Qfoo\E.*\Qbar\E$'
}

@test "question mark wildcard is converted to . Perl regexp" {
    run -0 globToRegexp --perl-regexp 'f??bar'
    assert_output '^\Qf\E..\Qbar\E$'
}

@test "character classes are preserved to Perl regexp" {
    run -0 globToRegexp --perl-regexp 'f[aeiou][aeiou]ba[^aeiou]'
    assert_output '^\Qf\E[aeiou][aeiou]\Qba\E[^aeiou]$'
}

@test "negated character class has ! converted to ^ Perl regexp" {
    run -0 globToRegexp --perl-regexp 'f[!aeiou]bar'
    assert_output '^\Qf\E[^aeiou]\Qbar\E$'
}

@test "character class including [ to Perl regexp" {
    run -0 globToRegexp --perl-regexp 'f[[]bar'
    assert_output '^\Qf\E[[]\Qbar\E$'
}

@test "backslash is escaped to Perl regexp" {
    run -0 globToRegexp --perl-regexp 'f\\b\r'
	assert_output '^\Qf\E\\\\\Qb\E\\\Qr\E$'
}

@test "more special characters are escaped to Perl regexp" {
    run -0 globToRegexp --perl-regexp 'f$^*+?.()|{}bar'
	assert_output '^\Qf$^\E.*\Q+\E.\Q.()|{}bar\E$'
}
