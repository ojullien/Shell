#!/bin/bash
## -----------------------------------------------------------------------------
## Linux Scripts.
## Clean logs.
##
## @package ojullien\Shell\bin
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------
#set -o errexit
set -o nounset
set -o pipefail

## -----------------------------------------------------------------------------
## Shell scripts directory, eg: /root/work/Shell/src/bin
## -----------------------------------------------------------------------------
readonly m_DIR_REALPATH="$(realpath "$(dirname "$0")")"

## -----------------------------------------------------------------------------
## Load constants
## -----------------------------------------------------------------------------
# shellcheck source=/dev/null
. "${m_DIR_REALPATH}/../sys/constant.sh"

## -----------------------------------------------------------------------------
## Includes sources & configuration
## -----------------------------------------------------------------------------
# shellcheck source=/dev/null
. "${m_DIR_SYS}/runasroot.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/string.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/filesystem.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/option.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/config.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/service.sh"
# shellcheck source=/dev/null
. "${m_DIR_APP}/clean/app.sh"
Config::load "manageservices"
Config::load "clean"

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
Constant::trace
ManageServices::trace
Clean::trace

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename "$0") process is: $$"
Console::waitUser

## -----------------------------------------------------------------------------
## Disable & stop services
## -----------------------------------------------------------------------------
String::separateLine
Service::disableServices ${m_SERVICES_DISABLE}
String::separateLine
Service::stopServices ${m_SERVICES_STOP}
Console::waitUser

## -----------------------------------------------------------------------------
## Clean logs
## -----------------------------------------------------------------------------
String::separateLine
Clean::main
Console::waitUser

## -----------------------------------------------------------------------------
## Start services
## -----------------------------------------------------------------------------
String::separateLine
Service::startServices ${m_SERVICES_START}

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
exit 0
