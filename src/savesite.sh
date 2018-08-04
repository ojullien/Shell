#!/bin/bash

## -----------------------------------------------------------------------------
## Linux Scripts.
## Save web site folder
##
## @category Linux Scripts
## @package saveSite
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
. "${m_DIR_APP}/savesite/inc/savesite.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "${m_DIR_SYS_CFG}/root.cfg.sh"
. "${m_DIR_SYS_CFG}/main.cfg.sh"
if [[ -f "${m_DIR_APP}/savesite/cfg/priv-savesite.cfg.sh" ]]; then
    . "${m_DIR_APP}/savesite/cfg/priv-savesite.cfg.sh"
else
    . "${m_DIR_APP}/savesite/cfg/savesite.cfg.sh"
fi

## -----------------------------------------------------
## Parse the app options and arguments
## -----------------------------------------------------
declare -i iReturn

while (( "$#" )); do
    case "$1" in
    -d|--destination) # app option
        m_SAVESITE_SAVEFOLDER="$2"
        shift 2
        FileSystem::checkDir "The destination directory is set to:\t${m_SAVESITE_SAVEFOLDER}" "${m_SAVESITE_SAVEFOLDER}"
        ;;
    -*|--*=) # unknown option
        shift
        String::separateLine
        SaveSite::showHelp
        exit 0
        ;;
    *) # We presume its a /etc/conf directory
        String::separateLine
        SaveSite::save "$1" "${m_SAVESITE_SAVEFOLDER}"
        iReturn=$?
        ((0!=iReturn)) && exit ${iReturn}
        cd "${m_DIR_SCRIPT}" || exit 18
        shift
        Console::waitUser
        ;;
    esac
done

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
exit 0
