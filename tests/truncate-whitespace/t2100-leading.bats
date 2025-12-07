#!/usr/bin/env bats

load fixture

@test "truncate leading" {
    runWithInputFileEOF -0 "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --leading
    output="${output%EOF}" assert_output "foo
here  

huhu	
bar


"
}

@test "truncate leading whitespace" {
    runWithInputFileEOF -0 "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --leading --whitespace
    output="${output%EOF}" assert_output "

foo
here  

huhu	
bar


"
}

@test "truncate leading blank lines" {
    runWithInputFileEOF -0 "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --leading --blank-lines
    output="${output%EOF}" assert_output "foo
  here  

	huhu	
bar
		

"
}

@test "truncate leading empty lines" {
    runWithInputFileEOF -0 "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --leading --empty-lines
    output="${output%EOF}" assert_output "   
foo
  here  

	huhu	
bar
		

"
}
