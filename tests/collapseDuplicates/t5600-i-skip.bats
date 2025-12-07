#!/usr/bin/env bats

load fixture

readonly LF=$'\r'

@test "interactive match counting skips patterns" {
    run -0 collapseDuplicates --unbuffered --as count --regexp 'repeat' --regexp '^Not ' --regexp 'ly.$' --skip '[[:upper:]]{3,}' --skip '!$' <<-'EOF'
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
    assert_output - <<EOF
This will repeat.${LF}This is the repeat. (2)
This is a BAD repeat.
A unique statement.
Not unique.
Not counted!
Not that important!
Not unique.
Seriously.${LF}Seriously? (2)
Seriously!
Seriously:${LF}Seriously. (2)
EOF
}

@test "interactive match accumulative counting skips patterns" {
    run -0 collapseDuplicates --unbuffered --as count --accumulate 'repeat' --accumulate '^Not ' --accumulate 'ly.$' --skip '[[:upper:]]{3,}' --skip '!$' <<-'EOF'
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
    assert_output - <<EOF
This will repeat.${LF}This is the repeat. (2)
This is a BAD repeat.
A unique statement.
Not unique.
Not counted!
Not that important!
Not unique. (2)
Seriously.${LF}Seriously? (2)
Seriously!
Seriously: (3)${LF}Seriously. (4)
EOF
}
