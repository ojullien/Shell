#!/bin/bash

## -----------------------------------------------------------------------------
## Linux Scripts.
## Update system.
##
## @category Linux Scripts
## @package Scripts
## @version 20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Load constants
## -----------------------------------------------------------------------------
. "./sys/cfg/constant.cfg.sh"

## -----------------------------------------------------------------------------
## Includes
## -----------------------------------------------------------------------------
. "${m_DIR_SYS_INC}/string.inc.sh"
. "${m_DIR_SYS_INC}/filesystem.inc.sh"
. "${m_DIR_SYS_INC}/option.inc.sh"
. "${m_DIR_SYS_INC}/apt.inc.sh"
. "${m_DIR_SYS_INC}/service.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "${m_DIR_SYS_CFG}/main.cfg.sh"
. "${m_DIR_SYS_CFG}/root.cfg.sh"
. "${m_DIR_APP}/disableservices/cfg/disableservices.cfg.sh"

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename "$0") process is: $$"
Console::waitUser

## -----------------------------------------------------------------------------
## Update and upgrade
## -----------------------------------------------------------------------------
Apt::updateAndUpgrade
Console::waitUser

## -----------------------------------------------------------------------------
## Clean
## -----------------------------------------------------------------------------
Apt::cleanAndPurge
Console::waitUser

## -----------------------------------------------------------------------------
## Display Linux selections
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Linux selections"
dpkg --get-selections | grep -Ei "Linux-headers|linux-image"
Console::waitUser

## -----------------------------------------------------------------------------
## Find orphan
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Find orphan"
deborphan
Console::waitUser

String::separateLine
String::notice "Find orphan config"
deborphan --find-config
Console::waitUser

## -----------------------------------------------------------------------------
## Purge locales
## -----------------------------------------------------------------------------
String::separateLine
local -i iReturn
String::notice -n "Removing unneeded localizations:"
localepurge
iReturn=$?
if (( 0 == iReturn )); then
   String::success "OK"
else
   String::error "NOK code: ${iReturn}"
fi
Console::waitUser

## -----------------------------------------------------------------------------
## Disable services
## -----------------------------------------------------------------------------
disableServices $m_SERVICES_DISABLE

## -----------------------------------------------------------------------------
## updateDB
## -----------------------------------------------------------------------------
String::separateLine
String::notice -n "Updating database for mlocate:"
updatedb
iReturn=$?
if (( 0 == iReturn )); then
   String::success "OK"
else
   String::error "NOK code: ${iReturn}"
fi

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
