#!/bin/sh

## -----------------------------------------------------------------------------
## Linux Scripts.
## Install logwatch.
##
## @category  Linux Scripts
## @package   Scripts
## @version   20170904
## @copyright (©) 2017, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------------------------------

set -u;

## -----------------------------------------------------------------------------
## Includes
## -----------------------------------------------------------------------------
. "./sys/inc/string.inc"
. "./sys/inc/filesystem.inc"
. "./sys/inc/option.inc"
. "./sys/inc/apt.inc"
. "./sys/inc/service.inc"
. "./app/install/inc/install.inc"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "./sys/cfg/main.cnf"
. "./sys/cfg/root.cnf"
. "./app/install/cfg/install.cnf"

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
separateLine
notice "Today is: `/bin/date -R`"
notice "The PID for `/usr/bin/basename $0` process is: $$"
waitUser

## -----------------------------------------------------------------------------
## Install logwatch
## -----------------------------------------------------------------------------
installPackage "chkrootkit debsums logwatch"
waitUser

## -----------------------------------------------------------------------------
## Logwatch
## -----------------------------------------------------------------------------
notice "Configure Logwatch"
configureLogwatch $m_LOGWATCH_SOURCE $m_LOGWATCH_DESTINATION
waitUser

## -----------------------------------------------------------------------------
## Mlocate
## -----------------------------------------------------------------------------
notice -n "Updating a database for mlocate:"
updatedb
iReturn=$?
if [ 0 -eq $iReturn ]; then
    success "OK"
else
    error "NOK code: $iReturn"
fi
waitUser

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
notice "Now is: `/bin/date -R`"