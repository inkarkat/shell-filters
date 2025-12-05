#!/usr/bin/env bats

load fixture

runPipLog()
{
    CONGLOMERATEDLINESFROM_CURRENT_LINE_PREFIX='' \
	run "$@" conglomeratedLinesFrom --take 3 --record 10 --all --reset-after-print \
	    --skip '(Retry([^)]+))' --match '^WARNING: Retrying \x00 after connection broken by' \
	    --match '^fatal: unable to access ' \
	    --match '^Note: Cannot validate URL due to network unavailability:' \
	    -- dishOutSections --basedir "$BATS_TEST_TMPDIR" -- "${BATS_TEST_DIRNAME}/piplog.txt"
}

@test "remove hiccups from pip log" {
    NOW=1764929190.000000000 runPipLog
    assert_output ''

    NOW=1764929191.000000000 runPipLog
    assert_output ''

    NOW=1764929192.000000000 runPipLog
    assert_output - <<'EOF'
12/05/25 10:06:30.000000000	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/urllib3/
12/05/25 10:06:31.000000000	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/pyyaml/
                           	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/types-click-default-group/
                           	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/pycups/
EOF

    NOW=1764929193.000000000 runPipLog
    assert_output ''

    NOW=1764929194.000000000 runPipLog
    assert_output ''

    NOW=1764929195.000000000 runPipLog
    assert_output ''

    NOW=1764929196.000000000 runPipLog
    assert_output ''

    NOW=1764929197.000000000 runPipLog
    assert_output - <<'EOF'
12/05/25 10:06:30.000000000	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/urllib3/
12/05/25 10:06:31.000000000	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/pyyaml/
12/05/25 10:06:32.000000000	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/types-click-default-group/
12/05/25 10:06:32.000000000	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/pycups/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-pyinstaller/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/cssselect/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-psycopg2/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-simplejson/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/kiwisolver/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-tree-sitter/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-bleach/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-pyasn1/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-docopt/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-whatthepatch/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-inifile/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-decorator/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-six/
12/05/25 10:06:34.000000000	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/types-pyasn1/
12/05/25 10:06:34.000000000	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/wheel/
                           	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'NewConnectionError('<pip._vendor.urllib3.connection.HTTPSConnection object at 0x7a2d0f583500>: Failed to establish a new connection: [Errno -3] Temporary failure in name resolution')': /simple/argcomplete/
                           	WARNING: Retrying (Retry(total=3, connect=None, read=None, redirect=None, status=None)) after connection broken by 'NewConnectionError('<pip._vendor.urllib3.connection.HTTPSConnection object at 0x7a2d0eed8710>: Failed to establish a new connection: [Errno -3] Temporary failure in name resolution')': /simple/argcomplete/
                           	WARNING: Retrying (Retry(total=2, connect=None, read=None, redirect=None, status=None)) after connection broken by 'NewConnectionError('<pip._vendor.urllib3.connection.HTTPSConnection object at 0x7a2d0eed8c20>: Failed to establish a new connection: [Errno -3] Temporary failure in name resolution')': /simple/argcomplete/
                           	WARNING: Retrying (Retry(total=1, connect=None, read=None, redirect=None, status=None)) after connection broken by 'NewConnectionError('<pip._vendor.urllib3.connection.HTTPSConnection object at 0x7a2d0eed8d70>: Failed to establish a new connection: [Errno -3] Temporary failure in name resolution')': /simple/argcomplete/
EOF

    NOW=1764929198.000000000 runPipLog
    assert_output ''

    NOW=1764929199.000000000 runPipLog
    assert_output ''

    NOW=1764929199.000000000 runPipLog
    assert_output ''

    NOW=1764929200.000000000 runPipLog
    assert_output - <<'EOF'
12/05/25 10:06:31.000000000	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/pyyaml/
12/05/25 10:06:32.000000000	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/types-click-default-group/
12/05/25 10:06:32.000000000	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/pycups/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-pyinstaller/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/cssselect/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-psycopg2/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-simplejson/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/kiwisolver/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-tree-sitter/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-bleach/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-pyasn1/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-docopt/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-whatthepatch/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-inifile/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-decorator/
12/05/25 10:06:33.000000000	WARNING: Retrying (Retry(total=9, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=120.0)")': /simple/types-six/
12/05/25 10:06:34.000000000	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/types-pyasn1/
12/05/25 10:06:34.000000000	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/wheel/
12/05/25 10:06:37.000000000	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'NewConnectionError('<pip._vendor.urllib3.connection.HTTPSConnection object at 0x7a2d0f583500>: Failed to establish a new connection: [Errno -3] Temporary failure in name resolution')': /simple/argcomplete/
12/05/25 10:06:37.000000000	WARNING: Retrying (Retry(total=3, connect=None, read=None, redirect=None, status=None)) after connection broken by 'NewConnectionError('<pip._vendor.urllib3.connection.HTTPSConnection object at 0x7a2d0eed8710>: Failed to establish a new connection: [Errno -3] Temporary failure in name resolution')': /simple/argcomplete/
12/05/25 10:06:37.000000000	WARNING: Retrying (Retry(total=2, connect=None, read=None, redirect=None, status=None)) after connection broken by 'NewConnectionError('<pip._vendor.urllib3.connection.HTTPSConnection object at 0x7a2d0eed8c20>: Failed to establish a new connection: [Errno -3] Temporary failure in name resolution')': /simple/argcomplete/
12/05/25 10:06:37.000000000	WARNING: Retrying (Retry(total=1, connect=None, read=None, redirect=None, status=None)) after connection broken by 'NewConnectionError('<pip._vendor.urllib3.connection.HTTPSConnection object at 0x7a2d0eed8d70>: Failed to establish a new connection: [Errno -3] Temporary failure in name resolution')': /simple/argcomplete/
12/05/25 10:06:38.000000000	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/jeepney/
12/05/25 10:06:39.000000000	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'ReadTimeoutError("HTTPSConnectionPool(host='pypi.org', port=443): Read timed out. (read timeout=15)")': /simple/iotop/
                           	WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'NewConnectionError('<pip._vendor.urllib3.connection.HTTPSConnection object at 0x78c3017c3560>: Failed to establish a new connection: [Errno -3] Temporary failure in name resolution')': /simple/argcomplete/
                           	WARNING: Retrying (Retry(total=3, connect=None, read=None, redirect=None, status=None)) after connection broken by 'NewConnectionError('<pip._vendor.urllib3.connection.HTTPSConnection object at 0x78c3012d45c0>: Failed to establish a new connection: [Errno -3] Temporary failure in name resolution')': /simple/argcomplete/
EOF

    NOW=1764929200.000000000 runPipLog
    assert_output ''

    NOW=1764929201.000000000 runPipLog -4
    assert_output ''
}
