#!/usr/bin/env bats

load fixture

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "single matches in a line are highlighted" {
    run -0 extractMatches --matches fo+ <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
This has [foo] in it.
All simple lines.
More [foooo] here.
Seriously.
EOF
}

@test "only the first identical match in a line is highlighted" {
    run -0 extractMatches --matches fo+ <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    assert_output - <<'EOF'
This has [foo], foo and foofoo in it.
More [foooo] and foo here.
EOF
}

@test "all matches in a line are highlighted with --global" {
    run -0 extractMatches --matches fo+ --global <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    assert_output - <<'EOF'
This has [foo], [foo] and [foo][foo] in it.
More [foooo] and [foo] here.
EOF
}

@test "two different matches in a line are highlighted" {
    run -0 extractMatches --matches fo+ --global --matches '\<\w{4}\>' --global <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple text.
More foo here.
Seriously, why?
EOF
    assert_output - <<'EOF'
[Just] [some] [sexy] [text].
[This] has [foo], [foo] and [foo][foo] in it.
All simple [text].
[More] [foo] [here].
Seriously, why?
EOF
}

@test "earlier matches consume those given later" {
    run -0 extractMatches --matches fo+ --global --matches oo --global --matches o+ --global --matches 'ex' --matches 'x' --global <<-'EOF'
Just some sexy text.
This has foo, boooo and mooo in it.
EOF
    assert_output - <<'EOF'
Just s[o]me s[ex]y te[x]t.
This has [foo], b[oo][oo] and m[oo][o] in it.
EOF
}

@test "combination of matches and counts in a line are highlighted" {
    run -0 extractMatches --match-count fo+ --global --matches '\<\w{4}\>' --global <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple text.
More foo here.
Seriously, why?
EOF
    assert_output - <<'EOF'
[Just] [some] [sexy] [text].
[This] has [foo (1)], [foo (2)] and [foo (3)][foo (4)] in it.
All simple [text].
[More] [foo (5)] [here].
Seriously, why?
EOF
}
