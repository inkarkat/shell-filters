#!/usr/bin/env bats

load fixture

@test "output by default is unbuffered if directly to a terminal" {
    # Force printing directly to terminal, even if stdout is redirected.
    { exec >/dev/tty; } 2>/dev/null || skip "Cannot reconnect output to terminal"

    # Flash reporting will only work with unbuffered output; we can use that to
    # check for it.
    extractMatches --to flash --regexp fo+  <<<"foo"
}
