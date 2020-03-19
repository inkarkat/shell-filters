TARGET := wbin/deleteStackTraceLocations.sed

all: $(TARGET)

# Windows doesn't understand the ANSI escape sequences used for highlighting,
# and script execution would require a Bash. Therefore, extract the pure sed
# commands, so that those can be passed to sed in a dosbatch wrapper in
# ~/public/tools/deleteStackTraceLocations.cmd
wbin/deleteStackTraceLocations.sed: bin/deleteStackTraceLocations
	mkdir -p $(@D)
	printf '#!/bin/sed -f\n' > $@
	printf '# This is an automatically generated file.\n# Created %s from %s.\n\n' "$$(date)" "$<" >> $@
	SED='printf %s\x20' ./$< --no-color | grep -v -e ' -e $$' >> $@
	chmod +x -- $@


.PHONY: clean
clean:
	rm -rf *.o $(TARGET)
