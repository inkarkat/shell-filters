#!/usr/bin/env bats

load fixture

@test "match counting skips patterns" {
    run -0 collapseDuplicates --as count --regexp 'repeat' --regexp '^Not ' --regexp 'ly.$' --skip '[[:upper:]]{3,}' --skip '!$' <<-'EOF'
This will repeat.
This is the repeat.
This is a BAD repeat.
A unique statement.
Not unique.
Not counted!
Not that important!
Not unique.
Seriously.
Seriously?
Seriously!
Seriously:
Seriously.
EOF
    assert_output - <<'EOF'
This will repeat. (2)
This is a BAD repeat.
A unique statement.
Not unique.
Not counted!
Not that important!
Not unique.
Seriously. (2)
Seriously!
Seriously: (2)
EOF
}

@test "match accumulative counting skips patterns" {
    run -0 collapseDuplicates --as count --accumulate 'repeat' --accumulate '^Not ' --accumulate 'ly.$' --skip '[[:upper:]]{3,}' --skip '!$' <<-'EOF'
This will repeat.
This is the repeat.
This is a BAD repeat.
A unique statement.
Not unique.
Not counted!
Not that important!
Not unique.
Seriously.
Seriously?
Seriously!
Seriously:
Seriously.
EOF
    assert_output - <<'EOF'
This will repeat. (2)
This is a BAD repeat.
A unique statement.
Not unique.
Not counted!
Not that important!
Not unique. (2)
Seriously. (2)
Seriously!
Seriously: (4)
EOF
}
