#!/bin/bash

## -----------------------------------------------------------------------------
## Linux Scripts.
## Install logwatch.
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
. "${m_DIR_APP}/install/inc/install.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "${m_DIR_SYS_CFG}/root.cfg.sh"
. "${m_DIR_SYS_CFG}/main.cfg.sh"
if [[ -f "${m_DIR_APP}/install/cfg/priv-install.cfg.sh" ]]; then
    . "${m_DIR_APP}/install/cfg/priv-install.cfg.sh"
else
    . "${m_DIR_APP}/install/cfg/install.cfg.sh"
fi

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename "$0") process is: $$"
Console::waitUser

## -----------------------------------------------------------------------------
## Install logwatch
## -----------------------------------------------------------------------------
String::separateLine
Apt::installPackage "chkrootkit" "debsums" "logwatch"
Console::waitUser

## -----------------------------------------------------------------------------
## Logwatch
## -----------------------------------------------------------------------------
String::separateLine
Install::configureLogwatch "${m_LOGWATCH_SOURCE}" "${m_LOGWATCH_DESTINATION}"
Console::waitUser

## -----------------------------------------------------------------------------
## Mlocate
## -----------------------------------------------------------------------------
String::separateLine
Install::updateMlocate
Console::waitUser

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
exit 0
