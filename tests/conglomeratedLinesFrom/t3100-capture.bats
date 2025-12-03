#!/usr/bin/env bats

load fixture

runFixedOutErr()
{
    run conglomeratedLinesFrom "$@" -c 'echo message' -c 'echo error >&2' -c 'echo from stdout' -c 'echo from stderr >&2'
}

@test "both standard output and standard error are captured by default" {
    runFixedOutErr
    assert_output ''

    runFixedOutErr
    assert_output ''

    runFixedOutErr
    assert_output - <<'EOF'
message
error
from stdout
from stderr
EOF
}

@test "only record standard output" {
    runFixedOutErr --stdout
    assert_output - <<'EOF'
error
from stderr
EOF

    runFixedOutErr --stdout
    assert_output - <<'EOF'
error
from stderr
EOF

    runFixedOutErr --stdout
    assert_output - <<'EOF'
error
from stderr
message
from stdout
EOF
}

@test "only record standard error" {
    runFixedOutErr --stderr
    assert_output - <<'EOF'
message
from stdout
EOF

    runFixedOutErr --stderr
    assert_output - <<'EOF'
message
from stdout
EOF

    runFixedOutErr --stderr
    assert_output - <<'EOF'
message
from stdout
error
from stderr
EOF
}
