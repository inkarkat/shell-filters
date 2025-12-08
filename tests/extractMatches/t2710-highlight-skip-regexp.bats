#!/usr/bin/env bats

load fixture

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "^ matches after the end of a previous skip match" {
    run -0 extractMatches --skip-regexp '^[a-z]+: ' --regexp '^great' --global <<-'EOF'
great stuff
foo: great
foo: bar: great
not too great
EOF
    assert_output - <<'EOF'
[great] stuff
foo: [great]
foo: bar: great
not too great
EOF
}

@test "^ matches after the end of previous skip matches with --global" {
    run -0 extractMatches --skip-regexp '^[a-z]+: ' --global --regexp '^great' --global <<-'EOF'
great stuff
foo: great
foo: bar: great
not too great
EOF
    assert_output - <<'EOF'
[great] stuff
foo: [great]
foo: bar: [great]
not too great
EOF
}

@test "different skip matches" {
    run -0 extractMatches --skip-regexp '^[a-z]+: ' --skip-regexp '^INTER-' --regexp '^great' --global <<-'EOF'
great stuff
INTER-great stuff
INTER-INTER-great
foo: INTER-great
foo: bar: great
foo: INTER-bar: great
INTER-foo: great
not too great
EOF
    assert_output - <<'EOF'
[great] stuff
INTER-[great] stuff
INTER-INTER-great
foo: INTER-[great]
foo: bar: great
foo: INTER-bar: great
INTER-foo: [great]
not too great
EOF
}
