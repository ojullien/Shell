#!/bin/bash

## -----------------------------------------------------------------------------
## Linux Scripts.
## Clean logs.
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
. "${m_DIR_SYS_INC}/service.inc.sh"
. "${m_DIR_APP}/clean/inc/clean.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "${m_DIR_SYS_CFG}/main.cfg.sh"
. "${m_DIR_SYS_CFG}/root.cfg.sh"
. "${m_DIR_APP}/clean/cfg/clean.cfg.sh"

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
Service::disableServices ${m_CLEAN_SERVICES_DISABLE}
String::separateLine
Service::stopServices ${m_CLEAN_SERVICES_STOP}
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
Service::startServices ${m_CLEAN_SERVICES_START}

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
