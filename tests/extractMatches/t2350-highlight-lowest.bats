#!/usr/bin/env bats

load fixture

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "matches before counts before match-count" {
    run -0 extractMatches --regexp fo+ --global --count 'text|lines' --global --match-count '\<\w{4}\>' --global <<-'EOF'
Just some text.
This has foo and fooo and foooo in it.
All simple lines.
More fooo text here.
Seriously.
EOF
    assert_output - <<'EOF'
[Just (1)] [some (1)] [text (1)].
[This (1)] has [foo] and [fooo] and [foooo] in it.
All simple [lines (2)].
[More (1)] [fooo] [text (3)] [here (1)].
Seriously.
EOF
}

@test "match-count before counts before matches" {
    run -0 extractMatches --match-count '\<\w{4}\>' --global --count 'text|lines' --global --regexp fo+ --global <<-'EOF'
Just some text.
This has foo and fooo and foooo in it.
All simple lines.
More fooo text here.
Seriously.
EOF
    assert_output - <<'EOF'
[Just (1)] [some (1)] [text (1)].
[This (1)] has [foo] and [fooo (1)] and [foooo] in it.
All simple [lines (1)].
[More (1)] [fooo (2)] [text (2)] [here (1)].
Seriously.
EOF
}

@test "count before match-count before matches" {
    run -0 extractMatches --count 'text|lines' --global --match-count '\<\w{4}\>' --global --regexp fo+ --global <<-'EOF'
Just some text.
This has foo and fooo and foooo in it.
All simple lines.
More fooo text here.
Seriously.
EOF
    assert_output - <<'EOF'
[Just (1)] [some (1)] [text (1)].
[This (1)] has [foo] and [fooo (1)] and [foooo] in it.
All simple [lines (2)].
[More (1)] [fooo (2)] [text (3)] [here (1)].
Seriously.
EOF
}
