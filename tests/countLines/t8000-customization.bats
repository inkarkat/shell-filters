#!/usr/bin/env bats

load fixture

@test "output customization" {
    export COUNTLINES_RESET_PREFIX='<'
    export COUNTLINES_RESET_SUFFIX='>'
    export COUNTLINES_SUMMARY_PREFIX='=> '
    export COUNTLINES_SUMMARY_SUFFIX=' <='
    export COUNTLINES_PREPENDED_COUNT_PREFIX='['
    export COUNTLINES_PREPENDED_COUNT_SUFFIX=']'
    export COUNTLINES_APPENDED_COUNT_PREFIX='{'
    export COUNTLINES_APPENDED_COUNT_SUFFIX='}'
    runWithCannedInput countLines --prepend X --append stuff --reset-on '^....$'
    [ $status -eq 0 ]
    [ "$output" = "[X 1]foo{stuff 1}
[X 2]bar{stuff 2}
[X 3]baz{stuff 3}
[X 1]<hihi>{stuff 1}
[X 2]{stuff 2}
[X 3]something{stuff 3}
[X 4]is{stuff 4}
[X 5]wrong{stuff 5}
[X 1]<here>{stuff 1}
[X 2]{stuff 2}
[X 3]nothing{stuff 3}
[X 4]for{stuff 4}
[X 5]me{stuff 5}" ]
}
