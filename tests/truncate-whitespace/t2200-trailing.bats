#!/usr/bin/env bats

load fixture

@test "truncate trailing" {
    runWithInputFileEOF "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --trailing
    [ $status -eq 0 ]
    [ "${output%EOF}" = "

foo
  here

	huhu
bar
" ]
}

@test "truncate trailing whitespace" {
    runWithInputFileEOF "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --trailing --whitespace
    [ $status -eq 0 ]
    [ "${output%EOF}" = "

foo
  here

	huhu
bar


" ]
}

@test "truncate trailing blank lines" {
    runWithInputFileEOF "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --trailing --blank-lines
    [ $status -eq 0 ]
    [ "${output%EOF}" = "
   
foo
  here  

	huhu	
bar
" ]
}

@test "truncate trailing empty lines" {
    runWithInputFileEOF "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --trailing --empty-lines
    [ $status -eq 0 ]
    [ "${output%EOF}" = "
   
foo
  here  

	huhu	
bar
		
" ]
}
