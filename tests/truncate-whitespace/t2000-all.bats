#!/usr/bin/env bats

load fixture

@test "truncate all" {
    runWithFullOutput -0 truncate-whitespace --all < "${BATS_TEST_DIRNAME}/input.txt"
    output="${output%EOF}" assert_output "foo
here

huhu
bar
"
}

@test "truncate all whitespace" {
    runWithFullOutput -0 truncate-whitespace --all --whitespace < "${BATS_TEST_DIRNAME}/input.txt"
    output="${output%EOF}" assert_output "

foo
here

huhu
bar


"
}

@test "truncate all blank lines" {
    runWithFullOutput -0 truncate-whitespace --all --blank-lines < "${BATS_TEST_DIRNAME}/input.txt"
    output="${output%EOF}" assert_output "foo
  here  

	huhu	
bar
"
}

@test "truncate all empty lines" {
    runWithFullOutput -0 truncate-whitespace --all --empty-lines < "${BATS_TEST_DIRNAME}/input.txt"
    output="${output%EOF}" assert_output "   
foo
  here  

	huhu	
bar
		
"
}
