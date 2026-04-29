#!/usr/bin/env bats

load fixture

@test "truncate leading" {
    runWithFullOutput -0 truncate-whitespace --leading < "${BATS_TEST_DIRNAME}/input.txt"
    output="${output%EOF}" assert_output "foo
here  

huhu	
bar


"
}

@test "truncate leading whitespace" {
    runWithFullOutput -0 truncate-whitespace --leading --whitespace < "${BATS_TEST_DIRNAME}/input.txt"
    output="${output%EOF}" assert_output "

foo
here  

huhu	
bar


"
}

@test "truncate leading blank lines" {
    runWithFullOutput -0 truncate-whitespace --leading --blank-lines < "${BATS_TEST_DIRNAME}/input.txt"
    output="${output%EOF}" assert_output "foo
  here  

	huhu	
bar
		

"
}

@test "truncate leading empty lines" {
    runWithFullOutput -0 truncate-whitespace --leading --empty-lines < "${BATS_TEST_DIRNAME}/input.txt"
    output="${output%EOF}" assert_output "   
foo
  here  

	huhu	
bar
		

"
}
