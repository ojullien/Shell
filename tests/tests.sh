#!/bin/bash

## -----------------------------------------------------------------------------
## Linux Scripts.
## Run tests
##
## @package ojullien\Shell\tests
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

if [[ ${BASH_VERSINFO[0]} -lt 4 ]]; then
    echo "At least Bash version 4 is needed!" >&2
    exit 4
fi

## -----------------------------------------------------------------------------
## Shell scripts directory, eg: /root/work/Shell/tests
## -----------------------------------------------------------------------------
readonly m_DIR_REALPATH="$(realpath "$(dirname "$0")")"

## -----------------------------------------------------------------------------
## Load constants
## -----------------------------------------------------------------------------
# shellcheck source=/dev/null
. "${m_DIR_REALPATH}/framework/constant.sh"

## -----------------------------------------------------------------------------
## Includes sources
## -----------------------------------------------------------------------------
# shellcheck source=/dev/null
. "${m_DIR_SYS}/string.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/filesystem.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/option.sh"
# shellcheck source=/dev/null
. "${m_DIR_REALPATH}/framework/library.sh"

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
Test::Constant::trace

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename "$0") process is: $$"
Console::waitUser

# shellcheck source=/dev/null
. "${m_TEST_DIR_SYS}/string_test.sh"
Test::String::main
Console::waitUser

# shellcheck source=/dev/null
. "${m_TEST_DIR_SYS}/filesystem_test.sh"
Test::FileSystem::main
Console::waitUser

# shellcheck source=/dev/null
. "${m_DIR_SYS}/package.sh"
# shellcheck source=/dev/null
. "${m_TEST_DIR_SYS}/package_test.sh"
Test::Package::main
Console::waitUser

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
