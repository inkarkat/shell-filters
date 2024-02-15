#!/usr/bin/env bats

load fixture

@test "truncate leading" {
    runWithInputFileEOF "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --leading
    [ $status -eq 0 ]
    [ "${output%EOF}" = "foo
here  

huhu	
bar


" ]
}

@test "truncate leading whitespace" {
    runWithInputFileEOF "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --leading --whitespace
    [ $status -eq 0 ]
    [ "${output%EOF}" = "

foo
here  

huhu	
bar


" ]
}

@test "truncate leading blank lines" {
    runWithInputFileEOF "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --leading --blank-lines
    [ $status -eq 0 ]
    [ "${output%EOF}" = "foo
  here  

	huhu	
bar
		

" ]
}

@test "truncate leading empty lines" {
    runWithInputFileEOF "${BATS_TEST_DIRNAME}/input.txt" truncate-whitespace --leading --empty-lines
    [ $status -eq 0 ]
    [ "${output%EOF}" = "   
foo
  here  

	huhu	
bar
		

" ]
}
