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
# shellcheck source=/dev/null
. "${m_DIR_SYS}/package.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/service.sh"

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
Test::Constant::trace

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------

declare aPackages=("filesystem" "package" "string" "service")
declare -i iChoice=-1

while ((iChoice>=${#aPackages[*]})) || ((iChoice<0)); do

    String::separateLine
    declare -i iIndex=0
    echo "Packages list:"

    for iIndex in ${!aPackages[*]}
    do
        printf "%4d: %s\n" "$iIndex" "${aPackages[$iIndex]}"
    done

    echo -n "Enter your choice (0..$iIndex): "
    read -r -N 1 iChoice
    echo

done

String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename "$0") process is: $$"
Console::waitUser

# shellcheck source=/dev/null
. "${m_TEST_DIR_SYS}/${aPackages[$iChoice]}_test.sh"
Test::"${aPackages[$iChoice]}"::main
Console::waitUser

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
