#!/usr/bin/env bats

export EXTRACTMATCHES_COMMAND_UPDATE_DELAY=0
load command

@test "matches with special characters are passed to command with proper escaping" {
    run extractMatches --to command --regexp '\<note.*' <<-'EOF'
Please note that this is simple.
This note should send $$$
A note for Patrick O'Brian.
A note for "you" * 'me'?
Last note has		various	  whitespace.   
EOF
    assert_runs "note that this is simple.
note should send \$\$\$
note for Patrick O'Brian.
note for \"you\" * 'me'?
note has		various	  whitespace.   "
}
