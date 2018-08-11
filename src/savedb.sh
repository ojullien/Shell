#!/bin/bash

## -----------------------------------------------------------------------------
## Linux Scripts.
## Save database
##
## @category Linux Scripts
## @package SaveDB
## @version 20180811
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
. "${m_DIR_APP}/savedb/inc/savedb.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "${m_DIR_SYS_CFG}/root.cfg.sh"
. "${m_DIR_SYS_CFG}/main.cfg.sh"
if [[ -f "${m_DIR_APP}/savedb/cfg/priv-savedb.cfg.sh" ]]; then
    . "${m_DIR_APP}/savedb/cfg/priv-savedb.cfg.sh"
else
    . "${m_DIR_APP}/savedb/cfg/savedb.cfg.sh"
fi

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename "$0") process is: $$"
Console::waitUser

## -----------------------------------------------------------------------------
## Flush
## -----------------------------------------------------------------------------
String::separateLine
FileSystem::syncFile
MariaDB::flush "${m_DB_USR}" "${m_DB_PWD}"
Console::waitUser

## -----------------------------------------------------
## Parse the app options and arguments
## -----------------------------------------------------
declare -i iReturn

while (( "$#" )); do
    case "$1" in
    -d|--destination) # app option
        m_SAVEDB_SAVEFOLDER="$2"
        shift 2
        FileSystem::checkDir "The destination directory is set to:\t${m_SAVEDB_SAVEFOLDER}" "${m_SAVEDB_SAVEFOLDER}"
        ;;
    -*|--*=) # unknown option
        shift
        String::separateLine
        SaveDB::showHelp
        exit 0
        ;;
    *) # We presume its a /etc/conf directory
        String::separateLine
        SaveDB::save "${m_DB_USR}" "${m_DB_PWD}" "${m_SAVEDB_SAVEFOLDER}" "$1"
        iReturn=$?
        cd "${m_DIR_SCRIPT}" || exit 18
        ((0!=iReturn)) && exit ${iReturn}
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
