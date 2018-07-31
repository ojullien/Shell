#!/bin/bash

## -----------------------------------------------------------------------------
## Linux Scripts.
## AutoSave.
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
. "${m_DIR_APP}/autosave/inc/autosave.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "${m_DIR_SYS_CFG}/main.cfg.sh"
. "${m_DIR_SYS_CFG}/root.cfg.sh"
. "${m_DIR_APP}/clean/cfg/clean.cfg.sh"
. "${m_DIR_APP}/autosave/cfg/autosave.cfg.sh"

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
Service::disableServices ${m_CLEAN_SERVICES_DISABLE}
String::separateLine
Service::stopServices ${m_CLEAN_SERVICES_STOP}
Console::waitUser

## -----------------------------------------------------------------------------
## Synchronize
## -----------------------------------------------------------------------------
String::separateLine
FileSystem::syncFile

## -----------------------------------------------------------------------------
## Logwatch
## -----------------------------------------------------------------------------
String::separateLine
AutoSave::watchLog
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
Clean::processCleanLog
Console::waitUser

## -----------------------------------------------------------------------------
## Start services
## -----------------------------------------------------------------------------
String::separateLine
Service::startServices ${m_CLEAN_SERVICES_START}
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
String::notice "Prepare to upload and upload"
cd "${m_APP_AUTOSAVE_DIR_CACHE}" 2>/dev/null;
FileSystem::compressFile "${m_APP_AUTOSAVE_DIR_UPLOAD}/${m_DATE}" "${m_DATE}"
cd "${m_DIR_SCRIPT}" 2>/dev/null;

if [[ -f "${m_APP_AUTOSAVE_DIR_UPLOAD}/${m_DATE}.tar.bz2" ]]; then
    AutoSave::putFTP "${m_FTP_SRV}" "${m_FTP_USR}" "${m_FTP_PWD}" "${m_DATE}.tar.bz2" "." "${m_APP_AUTOSAVE_DIR_UPLOAD}"
    iReturn=$?
    String::notice -n "FTP ${m_DATE}.tar.bz2:"
    if (( 0 == iReturn )); then
        String::success "OK"
    else
        String::error "NOK code: ${iReturn}"
    fi
else
    String::error "NOK code: nothing to send or FTP mode is OFF"
    iReturn=0
fi
Console::waitUser

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
m_OPTION_LOG=0
[[ -f  ${m_LOGWATCH_FILE} ]] && $(cp "${m_LOGWATCH_FILE}" "${m_APP_AUTOSAVE_DIR_UPLOAD}")
[[ -f  ${m_LOGFILE} ]] && $(mv "${m_LOGFILE}" "${m_APP_AUTOSAVE_DIR_UPLOAD}")
String::notice -n "Changing upload directory owner:"
chown -R ojullien:ojullien "${m_APP_AUTOSAVE_DIR_UPLOAD}"
iReturn=$?
if (( 0 == iReturn )); then
    String::success "OK"
else
    String::error "NOK code: ${iReturn}"
fi

String::notice "Now is: $(date -R)"
exit $iReturn
