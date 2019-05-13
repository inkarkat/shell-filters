#!/bin/sed -f

:begin
# Java exception message
/^[a-z]\+\.[a-zA-Z_.]*\(Exception\|Error\): \|^Caused by: / {
    s/; \(nested exception is \)/\n    \1/g
    s/\(^\|\n\)\(Caused by: \)\?\([^:]\+: \)\([^\n]\+\)/\1\2\3\4/g
}
# Groovy exception message
/^Message: \|^Caused by / {
    s/; \(nested exception is \)/\n    \1/g
    s/\(^\|\n\)\(Message: \|Caused by \)\([^:]\+: \)\([^\n]\+\)/\1\2\3\4/g
}
# Only show a single line of stack traces.
/^\tat /b deleteStackTraceLocations

# Delete the header line that sometimes occurs before a Groovy stack trace.
/^    Line | Method$/D
# Only show a single line of Groovy stack traces.
/^->> \+[0-9]\+ | / {
    # Delete the separator after the exception source
    N
    s/\n\(- \)\+$//

    b deleteGroovyStackTraceLocations
}

b
#-------------------------------------------------------------------------------

:deleteStackTraceLocations
N;/\n\tat [^\n]*$/{
    # Test framework does not count as "us".
    /\n\tat / {
	s/\n[^\n]*$//
	b deleteStackTraceLocations
    }
    # When a following location is from us ...
    /\n\tat / {
	# ... and we do not have another one from us yet ...
	/\(^\|\n\)\tat .*\n/! {
	    # Keep it.
	    b deleteStackTraceLocations
	}
    }
    # Else delete it (and all following locations).
    s/\n[^\n]*$//
    b deleteStackTraceLocations
}
:printStackTraceLocations
/^\tat /{
    s/(\([^)]\+:[0-9]\+\))\(\n\|$\)/(\1)\2/
    s/\([a-zA-Z0-9_]\+\)(/\1(/
    s/\tat /\tat /

    P
    s/^[^\n]*\n//
    b printStackTraceLocations
}

# Remove any following summary of omitted frames; due to our deletions, the number is wrong, anyway.
/\(^\|\n\)\t\.\.\. [0-9]\+ common frames omitted$/D

b begin
#-------------------------------------------------------------------------------

:deleteGroovyStackTraceLocations
N;/ in \+[^ \n]*$/{
    # Condense the formatting.
    s/ \([0-9]\+\) | \([^ \n]\+\) \+in \+\([^ \n]\+\)/ \2() in \3:\1/g

    # Test framework does not count as "us".
    /\n.* in / {
	s/\n[^\n]*$//
	b deleteGroovyStackTraceLocations
    }
    # When a following location is from us ...
    /\n.* in / {
	# ... and we do not have another one from us yet ...
	/\(^\|\n\).* in .*\n/! {
	    # Keep it.
	    b deleteGroovyStackTraceLocations
	}
    }
    # Else delete it and all following locations.
    s/\n[^\n]*$//
    b deleteGroovyStackTraceLocations
}

:printGroovyStackTraceLocations
/^->> \+\|^| \+/{
    s/\([^ ]\+:[0-9]\+\)\(\n\|$\)/\1\2/
    s/\([a-zA-Z0-9_]\+\)()/\1()/
    s/ in / in /
    s/^->> \+\|^|/&/

    P
    s/^[^\n]*\n//
    b printGroovyStackTraceLocations
}

b begin
 
