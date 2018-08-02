#!/bin/bash

## -----------------------------------------------------------------------------
## Linux Scripts.
## Save host-specific system-wide configuration
##
## @category Linux Scripts
## @package saveSystemConf
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
. "${m_DIR_SYS_CFG}/root.cfg.sh"
. "${m_DIR_SYS_CFG}/main.cfg.sh"
if [[ -f "${m_DIR_APP}/savesystemconf/cfg/priv-savesystemconf.cfg.sh" ]]; then
    . "${m_DIR_APP}/savesystemconf/cfg/priv-savesystemconf.cfg.sh"
else
    . "${m_DIR_APP}/savesystemconf/cfg/savesystemconf.cfg.sh"
fi

## -----------------------------------------------------
## Parse the app options and arguments
## -----------------------------------------------------
declare -i iReturn

while (( "$#" )); do
    case "$1" in
    -d|--destination) # app option
        m_SAVECONF_SAVEFOLDER="$2"
        shift 2
        FileSystem::checkDir "The destination directory is set to:\t${m_SAVECONF_SAVEFOLDER}" "${m_SAVECONF_SAVEFOLDER}"
        ;;
    -*|--*=) # unknown option
        shift
        String::separateLine
        SaveSystemConf::showHelp
        exit 0
        ;;
    *) # We presume its a /etc/conf directory
        String::separateLine
        SaveSystemConf::save "$1" "${m_SAVECONF_SAVEFOLDER}"
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
