#!/bin/bash

## -----------------------------------------------------------------------------
## Linux Scripts.
## AutoSave.
##
## @category Linux Scripts
## @package AutoSave
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
. "${m_DIR_SYS_INC}/service.inc.sh"
. "${m_DIR_APP}/clean/inc/clean.inc.sh"
. "${m_DIR_APP}/autosave/inc/autosave.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "${m_DIR_SYS_CFG}/root.cfg.sh"
. "${m_DIR_SYS_CFG}/main.cfg.sh"
. "${m_DIR_APP}/disableservices/cfg/disableservices.cfg.sh"
. "${m_DIR_APP}/clean/cfg/clean.cfg.sh"
if [[ -f "${m_DIR_APP}/autosave/cfg/priv-autosave.cfg.sh" ]]; then
    . "${m_DIR_APP}/autosave/cfg/priv-autosave.cfg.sh"
else
    . "${m_DIR_APP}/autosave/cfg/autosave.cfg.sh"
fi

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
FileSystem::removeDirectory "${m_APP_AUTOSAVE_DIR_CACHE}"
FileSystem::createDirectory "${m_APP_AUTOSAVE_DIR_CACHE}/${m_DATE}"
FileSystem::createDirectory "${m_APP_AUTOSAVE_DIR_UPLOAD}"
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
FileSystem::compressFile "${m_APP_AUTOSAVE_DIR_CACHE}/${m_DATE}/log-${m_DATE}" "/var/log"
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
FileSystem::compressFile "${m_APP_AUTOSAVE_DIR_CACHE}/${m_DATE}/$(uname -n)-start" "/var/log"
Console::waitUser

## -----------------------------------------------------------------------------
## Prepare to upload and ftp
## -----------------------------------------------------------------------------
String::separateLine
declare -i iReturn
String::notice "Prepare to upload and upload"
cd "${m_APP_AUTOSAVE_DIR_CACHE}" || exit 18
FileSystem::compressFile "${m_APP_AUTOSAVE_DIR_UPLOAD}/${m_DATE}" "${m_DATE}"
cd "${m_DIR_SCRIPT}" || exit 18

if [[ -f "${m_APP_AUTOSAVE_DIR_UPLOAD}/${m_DATE}.tar.bz2" ]]; then
    AutoSave::putFTP "${m_FTP_SRV}" "${m_FTP_USR}" "${m_FTP_PWD}" "${m_DATE}.tar.bz2" "." "${m_APP_AUTOSAVE_DIR_UPLOAD}"
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
    FileSystem::copyFile "${m_LOGWATCH_FILE}" "${m_APP_AUTOSAVE_DIR_UPLOAD}"
fi
if [[ -f ${m_LOGFILE} ]]; then
    $(mv "${m_LOGFILE}" "${m_APP_AUTOSAVE_DIR_UPLOAD}")
fi

String::notice -n "Changing upload directory owner:"
chown -R "${UPLOAD_DIRECTORY_OWNER}":"${UPLOAD_DIRECTORY_OWNER}" "${m_APP_AUTOSAVE_DIR_UPLOAD}"
iReturn=$?
String::checkReturnValueForTruthiness ${iReturn}

String::notice "Now is: $(date -R)"
exit ${iReturn}
