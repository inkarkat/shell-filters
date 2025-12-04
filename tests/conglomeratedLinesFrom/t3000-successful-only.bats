#!/usr/bin/env bats

load fixture

runFlaggingElephants()
{
    run conglomeratedLinesFrom "$@" -- \
	pipelineBuilder \
	    --exec dishOutSections --basedir "$BATS_TEST_TMPDIR" -- "${BATS_TEST_DIRNAME}/animals.txt" \; \
	    --exec negateThis rg --no-line-number --passthru '^elephant$' \;
}

@test "only use animal reports that don't have elephants" {
    runFlaggingElephants --successful-only
    assert_output ''

    runFlaggingElephants --successful-only
    assert_output - <<'EOF'
cat
dog
dog
elephant
EOF

    runFlaggingElephants --successful-only
    assert_output ''

    runFlaggingElephants --successful-only
    assert_output 'dog'

    runFlaggingElephants --successful-only
    assert_output - <<'EOF'
elephant
fox
horse
iguana
jellyfish
EOF

    runFlaggingElephants --successful-only
    assert_output - <<'EOF'
aardvark
bird
cat
EOF

    runFlaggingElephants --successful-only
    assert_output - <<'EOF'
aardvark
dog
elephant
EOF
}
