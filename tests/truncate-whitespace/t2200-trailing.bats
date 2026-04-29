#!/usr/bin/env bats

load fixture

@test "truncate trailing" {
    runWithFullOutput -0 truncate-whitespace --trailing < "${BATS_TEST_DIRNAME}/input.txt"
    output="${output%EOF}" assert_output "

foo
  here

	huhu
bar
"
}

@test "truncate trailing whitespace" {
    runWithFullOutput -0 truncate-whitespace --trailing --whitespace < "${BATS_TEST_DIRNAME}/input.txt"
    output="${output%EOF}" assert_output "

foo
  here

	huhu
bar


"
}

@test "truncate trailing blank lines" {
    runWithFullOutput -0 truncate-whitespace --trailing --blank-lines < "${BATS_TEST_DIRNAME}/input.txt"
    output="${output%EOF}" assert_output "
   
foo
  here  

	huhu	
bar
"
}

@test "truncate trailing empty lines" {
    runWithFullOutput -0 truncate-whitespace --trailing --empty-lines < "${BATS_TEST_DIRNAME}/input.txt"
    output="${output%EOF}" assert_output "
   
foo
  here  

	huhu	
bar
		
"
}
