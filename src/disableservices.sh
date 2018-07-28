#!/bin/sh

## -----------------------------------------------------------------------------
## Linux Scripts.
## Stop services.
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
. "./app/disableservices/inc/disableservices.inc.sh"

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
## Disable services
## -----------------------------------------------------------------------------
disableServices $m_SERVICES_DISABLE

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
notice "Now is: `/bin/date -R`"