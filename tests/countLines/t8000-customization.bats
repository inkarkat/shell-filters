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
    export COUNTLINES_COUNT_FORMAT='%02d'
    runWithCannedInput countLines --prepend X --append stuff --reset-on '^....$'
    [ $status -eq 0 ]
    [ "$output" = "[X 01]foo{stuff 01}
[X 02]bar{stuff 02}
[X 03]baz{stuff 03}
[X 01]<hihi>{stuff 01}
[X 02]{stuff 02}
[X 03]something{stuff 03}
[X 04]is{stuff 04}
[X 05]wrong{stuff 05}
[X 01]<here>{stuff 01}
[X 02]{stuff 02}
[X 03]nothing{stuff 03}
[X 04]for{stuff 04}
[X 05]me{stuff 05}" ]
}
