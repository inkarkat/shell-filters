# Shell Filters

_A collection of shell scripts that filter input / file contents in various ways as a shell pipeline step._

![Build Status](https://github.com/inkarkat/shell-filters/actions/workflows/build.yml/badge.svg)

All of these transform some input into some output, potentially with other side effects.

### Dependencies

* Bash, GNU `awk`, GNU `sed`
* automated testing is done with _bats - Bash Automated Testing System_ (https://github.com/bats-core/bats-core)

### Installation

* The `./bin` subdirectory is supposed to be added to `PATH`.
* The [shell/aliases.sh](shell/aliases.sh) script (meant to be sourced in `.bashrc`) defines Bash aliases around the provided commands.
* The [shell/completions.sh](shell/completions.sh) script (meant to be sourced in `.bashrc`) defines Bash completions for the provided commands.
* The [profile/exports.sh](profile/exports.sh) sets up configuration; it only needs to be sourced once, e.g. from your `.profile`.
