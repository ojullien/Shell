#!/bin/bash
## -----------------------------------------------------------------------------
## Linux Scripts.
## Auto save.
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
. "${m_DIR_SYS}/ftp.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/service.sh"
Config::load "manageservices"
Config::load "clean"
# shellcheck source=/dev/null
. "${m_DIR_APP}/clean/app.sh"
Config::load "autosave"
# shellcheck source=/dev/null
. "${m_DIR_APP}/autosave/app.sh"

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
Constant::trace
ManageServices::trace
Clean::trace
AutoSave::trace

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename "$0") process is: $$"
Console::waitUser

## -----------------------------------------------------------------------------
## Creates directories
## -----------------------------------------------------------------------------
String::separateLine
FileSystem::removeDirectory "${m_AUTOSAVE_DIR_CACHE}"
FileSystem::createDirectory "${m_AUTOSAVE_DIR_CACHE}/${m_DATE}"
FileSystem::createDirectory "${m_AUTOSAVE_DIR_UPLOAD}"
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
## Logwatch
## -----------------------------------------------------------------------------
String::separateLine
FileSystem::syncFile
AutoSave::watchLog "${m_LOGWATCH_FILE}"
Console::waitUser

## -----------------------------------------------------------------------------
## System: save
## -----------------------------------------------------------------------------
String::separateLine
FileSystem::compressFile "${m_AUTOSAVE_DIR_CACHE}/${m_DATE}/log-${m_DATE}" "/var/log"
Console::waitUser

## -----------------------------------------------------------------------------
## System: clean and delete logs
## -----------------------------------------------------------------------------
String::separateLine
Clean::main
Console::waitUser

## -----------------------------------------------------------------------------
## Start services
## -----------------------------------------------------------------------------
String::separateLine
Service::startServices ${m_SERVICES_START}
Console::waitUser

## -----------------------------------------------------------------------------
## Save logs again
## -----------------------------------------------------------------------------
String::separateLine
FileSystem::syncFile
FileSystem::compressFile "${m_AUTOSAVE_DIR_CACHE}/${m_DATE}/$(uname -n)-start" "/var/log"
Console::waitUser

## -----------------------------------------------------------------------------
## Prepare to upload and ftp
## -----------------------------------------------------------------------------
String::separateLine
declare -i iReturn=1
declare sPWD
sPWD=$(pwd)

String::notice "Prepare to upload and upload"
cd "${m_AUTOSAVE_DIR_CACHE}" || exit 18
FileSystem::compressFile "${m_AUTOSAVE_DIR_UPLOAD}/${m_DATE}" "${m_DATE}"
cd "${sPWD}" || exit 18

if [[ -f "${m_AUTOSAVE_DIR_UPLOAD}/${m_DATE}.tar.bz2" ]]; then
    FTP::put "${m_FTP_SRV}" "${m_FTP_USR}" "${m_FTP_PWD}" "${m_DATE}.tar.bz2" "." "${m_AUTOSAVE_DIR_UPLOAD}"
    iReturn=$?
    String::notice -n "FTP ${m_DATE}.tar.bz2:"
    String::checkReturnValueForTruthiness ${iReturn}
else
    String::error "NOK code: nothing to send or FTP mode is OFF"
    iReturn=0
fi
Console::waitUser

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
m_OPTION_LOG=0
if [[ -f ${m_LOGWATCH_FILE} ]]; then
    FileSystem::copyFile "${m_LOGWATCH_FILE}" "${m_AUTOSAVE_DIR_UPLOAD}"
fi
if [[ -f ${m_LOGFILE} ]]; then
    mv "${m_LOGFILE:?}" "${m_AUTOSAVE_DIR_UPLOAD:?}"
fi

String::notice -n "Changing upload directory owner:"
chown -R "${m_AUTOSAVE_UPLOAD_DIRECTORY_OWNER}":"${m_AUTOSAVE_UPLOAD_DIRECTORY_OWNER}" "${m_AUTOSAVE_DIR_UPLOAD}"
iReturn=$?
String::checkReturnValueForTruthiness ${iReturn}

String::notice "Now is: $(date -R)"
exit ${iReturn}
