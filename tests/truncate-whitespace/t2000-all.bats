#!/usr/bin/env bats

load fixture

@test "truncate all" {
    runWithInputFileEOF -0 "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --all
    output="${output%EOF}" assert_output "foo
here

huhu
bar
"
}

@test "truncate all whitespace" {
    runWithInputFileEOF -0 "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --all --whitespace
    output="${output%EOF}" assert_output "

foo
here

huhu
bar


"
}

@test "truncate all blank lines" {
    runWithInputFileEOF -0 "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --all --blank-lines
    output="${output%EOF}" assert_output "foo
  here  

	huhu	
bar
"
}

@test "truncate all empty lines" {
    runWithInputFileEOF -0 "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --all --empty-lines
    output="${output%EOF}" assert_output "   
foo
  here  

	huhu	
bar
		
"
}
