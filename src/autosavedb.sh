#!/bin/bash

## -----------------------------------------------------------------------------
## Linux Scripts.
## Save databases.
##
## @category Linux Scripts
## @package AutoSavedb
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
. "${m_DIR_SYS_INC}/ftp.inc.sh"
. "${m_DIR_SYS_INC}/option.inc.sh"
. "${m_DIR_APP}/autosavedb/inc/autosavedb.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "${m_DIR_SYS_CFG}/root.cfg.sh"
. "${m_DIR_SYS_CFG}/main.cfg.sh"
if [[ -f "${m_DIR_APP}/autosavedb/cfg/priv-autosavedb.cfg.sh" ]]; then
    . "${m_DIR_APP}/autosavedb/cfg/priv-autosavedb.cfg.sh"
else
    . "${m_DIR_APP}/autosavedb/cfg/autosavedb.cfg.sh"
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
FileSystem::removeDirectory "${m_APP_AUTOSAVEDB_DIR_CACHE}"
FileSystem::createDirectory "${m_APP_AUTOSAVEDB_DIR_CACHE}/${m_DATE}"
FileSystem::createDirectory "${m_APP_AUTOSAVEDB_DIR_UPLOAD}"
Console::waitUser

## -----------------------------------------------------------------------------
## Flush
## -----------------------------------------------------------------------------
String::separateLine
FileSystem::syncFile
MariaDB::flush "${m_DB_USR}" "${m_DB_PWD}"
Console::waitUser

## -----------------------------------------------------------------------------
## For each databases
## -----------------------------------------------------------------------------
for sDatabase in ${m_APP_AUTOSAVEDB_DATABASES[@]}; do

    ## -----------------------------------------------------------------------------
    ## Check before saving
    ## -----------------------------------------------------------------------------
    String::separateLine
    FileSystem::syncFile
    MariaDB::check "${m_DB_USR}" "${m_DB_PWD}" "${sDatabase}"
    Console::waitUser

    ## -----------------------------------------------------------------------------
    ## Save database
    ## -----------------------------------------------------------------------------
    String::separateLine
    MariaDB::dump "${m_DB_USR}" "${m_DB_PWD}" "${sDatabase}" "${m_APP_AUTOSAVEDB_DIR_CACHE}/${m_DATE}/${sDatabase}-${m_DATE}-error.log" "${m_APP_AUTOSAVEDB_DIR_CACHE}/${m_DATE}/${sDatabase}-${m_DATE}.sql"
    Console::waitUser

done

## -----------------------------------------------------------------------------
## Prepare to upload
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Preparing to upload ..."
cd "${m_APP_AUTOSAVEDB_DIR_CACHE}" || exit 18
FileSystem::compressFile "${m_APP_AUTOSAVEDB_DIR_UPLOAD}/${m_DATE}-db" "${m_DATE}"
cd "${m_DIR_SCRIPT}" || exit 18
Console::waitUser

## -----------------------------------------------------------------------------
## Upload
## -----------------------------------------------------------------------------
String::separateLine
declare -i iReturn
String::notice "Uploading ..."
if [[ -f "${m_APP_AUTOSAVEDB_DIR_UPLOAD}/${m_DATE}-db.tar.bz2" ]]; then
    FTP::put "${m_FTP_SRV}" "${m_FTP_USR}" "${m_FTP_PWD}" "${m_DATE}-db.tar.bz2" "." "${m_APP_AUTOSAVEDB_DIR_UPLOAD}"
    iReturn=$?
    String::notice -n "FTP ${m_DATE}-db.tar.bz2:"
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
if [[ -f ${m_LOGFILE} ]]; then
    $(mv "${m_LOGFILE}" "${m_APP_AUTOSAVEDB_DIR_UPLOAD}")
fi

String::notice -n "Changing upload directory owner:"
chown -R "${UPLOAD_DIRECTORY_OWNER}":"${UPLOAD_DIRECTORY_OWNER}" "${m_APP_AUTOSAVEDB_DIR_UPLOAD}"
iReturn=$?
String::checkReturnValueForTruthiness ${iReturn}

String::notice "Now is: $(date -R)"
exit ${iReturn}
