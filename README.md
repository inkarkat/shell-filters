# Shell Filters

_A collection of shell scripts that filter input / file contents in various ways as a shell pipeline step._

![Build Status](https://github.com/inkarkat/shell-filters/actions/workflows/build.yml/badge.svg)

All of these transform some input into some output, potentially with other side effects.

### Dependencies

* Bash, GNU `awk`, GNU `sed`
* [`stripcmt`](https://github.com/DimonSE/stripcmt) (optional, for `nocomment`)
* [inkarkat/shell-basics](https://github.com/inkarkat/shell-basics) for the `conglomeratedLinesFrom` command
* [inkarkat/shell-filesystem](https://github.com/inkarkat/shell-filesystem) for the `conglomeratedLinesFrom` command
* [inkarkat/pipes](https://github.com/inkarkat/pipes) for the `conglomeratedLinesFrom` command
* [inkarkat/shell-scripting](https://github.com/inkarkat/shell-scripting) for automated tests
* automated testing is done with _bats - Bash Automated Testing System_ (https://github.com/bats-core/bats-core)

### Installation

* The `./bin` subdirectory is supposed to be added to `PATH`.
* The [shell/aliases.sh](shell/aliases.sh) script (meant to be sourced in `.bashrc`) defines Bash aliases around the provided commands.
* The [shell/completions.sh](shell/completions.sh) script (meant to be sourced in `.bashrc`) defines Bash completions for the provided commands.
* The [profile/exports.sh](profile/exports.sh) sets up configuration; it only needs to be sourced once, e.g. from your `.profile`.
