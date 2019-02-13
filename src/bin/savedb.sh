#!/bin/bash
## -----------------------------------------------------------------------------
## Linux Scripts.
## Save database.
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
. "${m_DIR_SYS}/string.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/filesystem.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/option.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/config.sh"
# shellcheck source=/dev/null
. "${m_DIR_APP}/savedb/app.sh"
Config::load "savedb"
if ((m_SAVEDB_ISMARIADB)); then
    # shellcheck source=/dev/null
    . "${m_DIR_SYS}/db/mariadb.sh"
else
    # shellcheck source=/dev/null
    . "${m_DIR_SYS}/db/mysql.sh"
fi

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
Constant::trace
SaveDB::trace

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
DB::flush "${m_DB_USR}" "${m_DB_PWD}"
Console::waitUser

## -----------------------------------------------------
## Parse the app options and arguments
## -----------------------------------------------------
declare -i iReturn=1
declare sPWD sDestination="${m_SAVEDB_DESTINATION_DEFAULT}"
sPWD=$(pwd)

(( 0==$# )) && SaveDB::showHelp && exit 1

while (( "$#" )); do
    case "$1" in
    -d|--destination) # app option
        sDestination="$2"
        shift 2
        FileSystem::checkDir "The destination directory is set to:\t${sDestination}" "${sDestination}"
        ;;
    --*|-*=) # unknown option
        shift
        String::separateLine
        SaveDB::showHelp
        exit 0
        ;;
    *) # We presume its a /etc/conf directory
        String::separateLine
        SaveDB::save "${m_DB_USR}" "${m_DB_PWD}" "${sDestination}" "$1"
        iReturn=$?
        cd "${sPWD}" || exit 18
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
