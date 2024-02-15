#!/usr/bin/env bats

load fixture

@test "truncate all" {
    runWithInputFileEOF "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --all
    [ $status -eq 0 ]
    [ "${output%EOF}" = "foo
here

huhu
bar
" ]
}

@test "truncate all whitespace" {
    runWithInputFileEOF "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --all --whitespace
    [ $status -eq 0 ]
    [ "${output%EOF}" = "

foo
here

huhu
bar


" ]
}

@test "truncate all blank lines" {
    runWithInputFileEOF "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --all --blank-lines
    [ $status -eq 0 ]
    [ "${output%EOF}" = "foo
  here  

	huhu	
bar
" ]
}

@test "truncate all empty lines" {
    runWithInputFileEOF "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --all --empty-lines
    [ $status -eq 0 ]
    [ "${output%EOF}" = "   
foo
  here  

	huhu	
bar
		
" ]
}
