#!/bin/bash

## -----------------------------------------------------------------------------
## Linux Scripts.
## Save a system configuration
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
. "${m_DIR_APP}/savesystemconf/inc/savesystemconf.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "${m_DIR_SYS_CFG}/main.cfg.sh"
. "${m_DIR_SYS_CFG}/root.cfg.sh"
. "${m_DIR_APP}/savesystemconf/cfg/savesystemconf.cfg.sh"

## -----------------------------------------------------------------------------
## Must have an argument
## -----------------------------------------------------------------------------
if [[ $# -eq 0 ]]; then
    Console::display "Usage: savesystemconf.sh <directory 1> [directory 2] ..."
    exit 2
fi

declare -i iReturn

until [[ -z "${1+defined}" ]]  # Until all parameters used up . . .
do
    String::separateLine
    SaveSystemConf::save "$1" "${m_SAVECONF_SAVEFOLDER}"
    iReturn=$?
    ((0!=iReturn)) && exit ${iReturn}
    cd "${m_DIR_SCRIPT}" || exit 18
    shift
done

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
