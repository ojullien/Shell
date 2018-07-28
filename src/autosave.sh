#!/bin/sh

## -----------------------------------------------------------------------------
## Linux Scripts.
## AutoSave.
##
## @category  Linux Scripts
## @package   Scripts
## @version   20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------------------------------

set -u;

## -----------------------------------------------------------------------------
## Includes
## -----------------------------------------------------------------------------
. "./sys/inc/string.inc.sh"
. "./sys/inc/filesystem.inc.sh"
. "./sys/inc/option.inc.sh"
. "./sys/inc/service.inc.sh"
. "./app/clean/inc/clean.inc.sh"
. "./app/autosave/inc/autosave.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "./sys/cfg/main.cfg.sh"
. "./sys/cfg/root.cfg.sh"
. "./app/clean/cfg/clean.cfg.sh"
. "./app/autosave/cfg/autosave.cfg.sh"

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
separateLine
notice "Today is: `/bin/date -R`"
notice "The PID for `/usr/bin/basename $0` process is: $$"
waitUser

## -----------------------------------------------------------------------------
## Creates directories
## -----------------------------------------------------------------------------
separateLine
removeDirectory "$m_APP_AUTOSAVE_DIR_CACHE"
createDirectory "${m_APP_AUTOSAVE_DIR_CACHE}/${m_DATE}"
createDirectory "$m_APP_AUTOSAVE_DIR_UPLOAD"
waitUser

## -----------------------------------------------------------------------------
## Disable & stop services
## -----------------------------------------------------------------------------
disableServices $m_CLEAN_SERVICES_DISABLE
stopServices $m_CLEAN_SERVICES_STOP
waitUser

## -----------------------------------------------------------------------------
## Synchronize
## -----------------------------------------------------------------------------
separateLine
syncFile

## -----------------------------------------------------------------------------
## Logwatch
## -----------------------------------------------------------------------------
separateLine
notice -n "Logwatch:"
logwatch --filename $m_LOGWATCH_FILE
iReturn=$?
if [ 0 -eq $iReturn ]; then
    success "OK"
else
    error "NOK code: $iReturn"
fi
waitUser

## -----------------------------------------------------------------------------
## System: save, clean and delete logs
## -----------------------------------------------------------------------------
separateLine
compressFile "$m_APP_AUTOSAVE_DIR_CACHE/$m_DATE/log-$m_DATE" "/var/log"
waitUser
separateLine
processCleanLog
waitUser

## -----------------------------------------------------------------------------
## Start services
## -----------------------------------------------------------------------------
startServices $m_CLEAN_SERVICES_START
waitUser

## -----------------------------------------------------------------------------
## Save logs again
## -----------------------------------------------------------------------------
separateLine
syncFile
compressFile "$m_APP_AUTOSAVE_DIR_CACHE/$m_DATE/`uname -n`-start" "/var/log"
waitUser

## -----------------------------------------------------------------------------
## Prepare to upload and ftp
## -----------------------------------------------------------------------------
separateLine
notice "Prepare to upload and upload"
cd $m_APP_AUTOSAVE_DIR_CACHE 2>/dev/null;
compressFile "$m_APP_AUTOSAVE_DIR_UPLOAD/$m_DATE" "$m_DATE"
cd $m_DIR_SCRIPT 2>/dev/null;

if [ -f "$m_APP_AUTOSAVE_DIR_UPLOAD/$m_DATE.tar.bz2" ]; then
    putFTP $m_FTP_SRV $m_FTP_USR $m_FTP_PWD $m_DATE.tar.bz2 "." $m_APP_AUTOSAVE_DIR_UPLOAD
    iReturn=$?
    notice -n "FTP $m_DATE.tar.bz2:"
    if [ 0 -eq $iReturn ]; then
        success "OK"
    else
        error "NOK code: $iReturn"
    fi
else
    error "NOK code: nothing to send or FTP mode is OFF"
    iReturn=0
fi
waitUser

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
m_OPTION_LOG=0
[ -f $m_LOGWATCH_FILE ] && cp $m_LOGWATCH_FILE $m_APP_AUTOSAVE_DIR_UPLOAD
[ -f $m_LOGFILE ] && mv $m_LOGFILE $m_APP_AUTOSAVE_DIR_UPLOAD
notice -n "Changing upload directory owner:"
chown -R ojullien:ojullien $m_APP_AUTOSAVE_DIR_UPLOAD
iReturn=$?
if [ 0 -eq $iReturn ]; then
    success "OK"
else
    error "NOK code: $iReturn"
fi
notice "Now is: `/bin/date -R`"
exit $iReturn
