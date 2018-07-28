#!/bin/sh

## -----------------------------------------------------------------------------
## Linux Scripts.
## Creates an apache user/group and a home directory in /var/www.
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
. "./app/createdomain/inc/createdomain.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "./app/createdomain/cfg/createdomain.cfg.sh"
. "./sys/cfg/main.cfg.sh"
. "./sys/cfg/root.cfg.sh"

## -----------------------------------------------------------------------------
## Must have an argument
## -----------------------------------------------------------------------------
[ $# -eq 0 ] && display "Usage: createDomain <domain 1> [domain 2] ..." && exit 2

until [ -z "${1+defined}" ]  # Until all parameters used up . . .
do
    createDirectory $1 && createGroup $1 && createUser $1 && changeOwner $1
    iReturn=$?
    if [ 0 -ne $iReturn ]; then
        exit $iReturn
    fi
    shift
done

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
notice "Now is: `/bin/date -R`"