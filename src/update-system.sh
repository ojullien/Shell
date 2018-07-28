#!/bin/sh

## -----------------------------------------------------------------------------
## Linux Scripts.
## Update system.
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
. "./sys/inc/apt.inc.sh"
. "./sys/inc/service.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "./sys/cfg/main.cfg.sh"
. "./sys/cfg/root.cfg.sh"
. "./app/disableservices/cfg/disableservices.cfg.sh"

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
separateLine
notice "Today is: `/bin/date -R`"
notice "The PID for `/usr/bin/basename $0` process is: $$"
waitUser

## -----------------------------------------------------------------------------
## Update and upgrade
## -----------------------------------------------------------------------------
updateAndUpgrade
waitUser

## -----------------------------------------------------------------------------
## Clean
## -----------------------------------------------------------------------------
cleanAndPurge
waitUser

## -----------------------------------------------------------------------------
## Display Linux selections
## -----------------------------------------------------------------------------
separateLine
notice "Linux selections"
dpkg --get-selections | grep -Ei "Linux-headers|linux-image"
waitUser

## -----------------------------------------------------------------------------
## Find orphan
## -----------------------------------------------------------------------------
separateLine
notice "Find orphan"
deborphan
waitUser

separateLine
notice "Find orphan config"
deborphan --find-config
waitUser

## -----------------------------------------------------------------------------
## Purge locales
## -----------------------------------------------------------------------------
separateLine
notice -n "Removing unneeded localizations:"
localepurge
iReturn=$?
if [ 0 -eq $iReturn ]; then
    success "OK"
else
    error "NOK code: $iReturn"
fi
waitUser

## -----------------------------------------------------------------------------
## Disable services
## -----------------------------------------------------------------------------
disableServices $m_SERVICES_DISABLE

## -----------------------------------------------------------------------------
## updateDB
## -----------------------------------------------------------------------------
separateLine
notice -n "Updating database for mlocate:"
updatedb
iReturn=$?
if [ 0 -eq $iReturn ]; then
    success "OK"
else
    error "NOK code: $iReturn"
fi

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
notice "Now is: `/bin/date -R`"