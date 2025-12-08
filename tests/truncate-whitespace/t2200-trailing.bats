#!/usr/bin/env bats

load fixture

@test "truncate trailing" {
    runWithInputFileEOF -0 "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --trailing
    output="${output%EOF}" assert_output "

foo
  here

	huhu
bar
"
}

@test "truncate trailing whitespace" {
    runWithInputFileEOF -0 "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --trailing --whitespace
    output="${output%EOF}" assert_output "

foo
  here

	huhu
bar


"
}

@test "truncate trailing blank lines" {
    runWithInputFileEOF -0 "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --trailing --blank-lines
    output="${output%EOF}" assert_output "
   
foo
  here  

	huhu	
bar
"
}

@test "truncate trailing empty lines" {
    runWithInputFileEOF -0 "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --trailing --empty-lines
    output="${output%EOF}" assert_output "
   
foo
  here  

	huhu	
bar
		
"
}
