#!/bin/bash

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
. "${m_DIR_SYS_INC}/string.inc.sh"
. "${m_DIR_SYS_INC}/filesystem.inc.sh"
. "${m_DIR_SYS_INC}/option.inc.sh"
. "${m_DIR_APP}/clean/inc/clean.inc.sh"
. "${m_DIR_SYS_INC}/service.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "${m_DIR_SYS_CFG}/main.cfg.sh"
. "${m_DIR_SYS_CFG}/root.cfg.sh"
. "${m_DIR_APP}/clean/cfg/clean.cfg.sh"

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename "$0") process is: $$"
Console::waitUser

## -----------------------------------------------------------------------------
## Disable & stop services
## -----------------------------------------------------------------------------
Service::disableServices $m_CLEAN_SERVICES_DISABLE
Service::stopServices $m_CLEAN_SERVICES_STOP

## -----------------------------------------------------------------------------
## Clean logs
## -----------------------------------------------------------------------------
String::separateLine
processCleanLog
Console::waitUser

## -----------------------------------------------------------------------------
## Clean logs
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Fills disk"
m_Disks="/ /home /usr /var /tmp"
for sArg in $m_Disks
do
    cd $sArg
   String::notice "Filling: `pwd`"
    cat /dev/zero > zeros
    sync
    rm -f zeros
done
cd $m_DIR_SCRIPT
String::notice "back to `pwd`"

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
Console::waitUser

shutdown -h now