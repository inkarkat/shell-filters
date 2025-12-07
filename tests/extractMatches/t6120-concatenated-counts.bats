#!/usr/bin/env bats

@test "single counts in a line are shown in concatenated line" {
    input="Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously."
    run -0 extractMatches --to concatenated --count fo+ <<<"$input"
    [ "$output" = "Just some text.
This has foo in it.
extracted matches: foo: 1
All simple lines.
More foo here.
extracted matches: foo: 2
Seriously." ]
}

@test "three different counts with different single / global are shown in concatenated line" {
    input="Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?"
    run -0 extractMatches --to concatenated --count fo+ --global --count 'ex' --count 'y' --global <<<"$input"
    [ "$output" = "Just some sexy text.
extracted matches: ex: 1, y: 1
This has foo, foo and foofoo in it.
extracted matches: foo: 4, ex: 1, y: 1
All simple lines.
More foo here.
extracted matches: foo: 5, ex: 1, y: 1
Seriously, why?
extracted matches: foo: 5, ex: 1, y: 3" ]
}
