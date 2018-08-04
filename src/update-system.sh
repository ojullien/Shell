#!/bin/bash

## -----------------------------------------------------------------------------
## Linux Scripts.
## Update system.
##
## @category Linux Scripts
## @package Update system
## @version 20180804
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
. "${m_DIR_APP}/update-system/inc/update-system.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "${m_DIR_SYS_CFG}/root.cfg.sh"
. "${m_DIR_SYS_CFG}/main.cfg.sh"
. "${m_DIR_APP}/disableservices/cfg/disableservices.cfg.sh"
. "${m_DIR_APP}/update-system/inc/update-system.inc.sh"

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
## Update and upgrade
## -----------------------------------------------------------------------------
String::separateLine
Apt::updateAndUpgrade
Console::waitUser

## -----------------------------------------------------------------------------
## Clean
## -----------------------------------------------------------------------------
String::separateLine
Apt::cleanAndPurge
Console::waitUser

## -----------------------------------------------------------------------------
## Display Linux selections
## -----------------------------------------------------------------------------
String::separateLine
Apt::displayLinuxSelections
Console::waitUser

## -----------------------------------------------------------------------------
## Find orphan
## -----------------------------------------------------------------------------
String::separateLine
UpdateSystem::findOrphan
Console::waitUser

String::separateLine
UpdateSystem::findOrphanConfig
Console::waitUser

## -----------------------------------------------------------------------------
## Purge locales
## -----------------------------------------------------------------------------
String::separateLine
UpdateSystem::purgeLocales
Console::waitUser

## -----------------------------------------------------------------------------
## updateDB
## -----------------------------------------------------------------------------
String::separateLine
UpdateSystem::updateDB
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
