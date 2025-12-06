#!/usr/bin/env bats

load fixture

runWarningsOnlyViaMatch()
{
    run conglomeratedLinesFrom "$@" --take 2 --record 3 \
	--match '^WARNING: ' \
	--reset-after-print \
	-- dishOutSections --basedir "$BATS_TEST_TMPDIR" -- "${BATS_TEST_DIRNAME}/piplog.txt"
}

@test "report warnings via match and other lines" {
    NOW=1764929190.000000000 runWarningsOnlyViaMatch
    assert_output ''

    NOW=1764929191.000000000 runWarningsOnlyViaMatch
    assert_output - <<'EOF'
WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/pyyaml/
EOF

    NOW=1764929192.000000000 runWarningsOnlyViaMatch
    assert_output ''
}

@test "report only warnings via match, directly print other lines via --grep" {
    NOW=1764929190.000000000 runWarningsOnlyViaMatch --grep '^WARNING: '
    assert_output ''

    NOW=1764929191.000000000 runWarningsOnlyViaMatch --grep '^WARNING: '
    assert_output - <<'EOF'
WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/pyyaml/
EOF

    NOW=1764929192.000000000 runWarningsOnlyViaMatch --grep '^WARNING: '
    assert_output - <<'EOF'
Note: Cannot validate URL due to network unavailability: https://proget.makedeb.org/dists/prebuilt-mpr/Release
fatal: unable to access 'https://github.com/deanproxy/eMail.git/': Could not resolve host: github.com
EOF
}

@test "report only warnings via match, directly print other lines via --only-partials" {
    NOW=1764929190.000000000 runWarningsOnlyViaMatch --only-partials
    assert_output ''

    NOW=1764929191.000000000 runWarningsOnlyViaMatch --only-partials
    assert_output - <<'EOF'
WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/pyyaml/
EOF

    NOW=1764929192.000000000 runWarningsOnlyViaMatch --only-partials
    assert_output - <<'EOF'
Note: Cannot validate URL due to network unavailability: https://proget.makedeb.org/dists/prebuilt-mpr/Release
fatal: unable to access 'https://github.com/deanproxy/eMail.git/': Could not resolve host: github.com
EOF
}


runWarningsOnlyViaSkip()
{
    run conglomeratedLinesFrom "$@" --take 2 --record 3 \
	--skip '\\(Retry\\([^)]+\\)\\)' --skip ': /simple/.*/$' \
	--reset-after-print \
	-- dishOutSections --basedir "$BATS_TEST_TMPDIR" -- "${BATS_TEST_DIRNAME}/piplog.txt"
}

@test "report warnings via skip and other lines" {
    NOW=1764929190.000000000 runWarningsOnlyViaSkip
    assert_output ''

    NOW=1764929191.000000000 runWarningsOnlyViaSkip
    assert_output - <<'EOF'
WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/pyyaml/
EOF

    NOW=1764929192.000000000 runWarningsOnlyViaSkip
    assert_output ''
}

@test "report only warnings via skip, directly print other lines via --grep" {
    NOW=1764929190.000000000 runWarningsOnlyViaSkip --grep '^WARNING: '
    assert_output ''

    NOW=1764929191.000000000 runWarningsOnlyViaSkip --grep '^WARNING: '
    assert_output - <<'EOF'
WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/pyyaml/
EOF

    NOW=1764929192.000000000 runWarningsOnlyViaSkip --grep '^WARNING: '
    assert_output - <<'EOF'
Note: Cannot validate URL due to network unavailability: https://proget.makedeb.org/dists/prebuilt-mpr/Release
fatal: unable to access 'https://github.com/deanproxy/eMail.git/': Could not resolve host: github.com
EOF
}

@test "report only warnings via skip, directly print other lines via --only-partials" {
    NOW=1764929190.000000000 runWarningsOnlyViaSkip --only-partials
    assert_output ''

    NOW=1764929191.000000000 runWarningsOnlyViaSkip --only-partials
    assert_output - <<'EOF'
WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/pyyaml/
EOF

    NOW=1764929192.000000000 runWarningsOnlyViaSkip --only-partials
    assert_output - <<'EOF'
Note: Cannot validate URL due to network unavailability: https://proget.makedeb.org/dists/prebuilt-mpr/Release
fatal: unable to access 'https://github.com/deanproxy/eMail.git/': Could not resolve host: github.com
EOF
}
