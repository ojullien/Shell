#!/bin/sh

## -----------------------------------------------------------------------------
## Linux Scripts.
## Fills disks with zero for compression.
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
. "./app/clean/inc/clean.inc.sh"
. "./sys/inc/service.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "./sys/cfg/main.cfg.sh"
. "./sys/cfg/root.cfg.sh"
. "./app/clean/cfg/clean.cfg.sh"

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
separateLine
notice "Today is: `/bin/date -R`"
notice "The PID for `/usr/bin/basename $0` process is: $$"
waitUser

## -----------------------------------------------------------------------------
## Disable & stop services
## -----------------------------------------------------------------------------
disableServices $m_CLEAN_SERVICES_DISABLE
stopServices $m_CLEAN_SERVICES_STOP

## -----------------------------------------------------------------------------
## Clean logs
## -----------------------------------------------------------------------------
separateLine
processCleanLog
waitUser

## -----------------------------------------------------------------------------
## Clean logs
## -----------------------------------------------------------------------------
separateLine
notice "Fills disk"
m_Disks="/ /home /usr /var /tmp"
for sArg in $m_Disks
do
    cd $sArg
    notice "Filling: `pwd`"
    cat /dev/zero > zeros
    sync
    rm -f zeros
done
cd $m_DIR_SCRIPT
notice "back to `pwd`"

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
notice "Now is: `/bin/date -R`"
waitUser

shutdown -h now