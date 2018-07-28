#!/bin/sh

## -----------------------------------------------------------------------------
## Linux Scripts.
## Install logwatch.
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
. "./app/install/inc/install.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "./sys/cfg/main.cfg.sh"
. "./sys/cfg/root.cfg.sh"
. "./app/install/cfg/install.cfg.sh"

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