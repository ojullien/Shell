#!/bin/sh

## -----------------------------------------------------------------------------
## Linux Scripts.
## Save a system configuration
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
. "./sys/inc/string.inc"
. "./sys/inc/filesystem.inc"
. "./app/savesystemconf/inc/savesystemconf.inc"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "./app/savesystemconf/cfg/savesystemconf.cnf"
. "./sys/cfg/main.cnf"
. "./sys/cfg/root.cnf"

## -----------------------------------------------------------------------------
## Must have an argument
## -----------------------------------------------------------------------------
[ $# -eq 0 ] && display "Usage: savesystemconf <directory 1> [directory 2] ..." && exit 2

until [ -z "${1+defined}" ]  # Until all parameters used up . . .
do
    saveConf $1 $m_SAVECONF_SAVEFOLDER
    iReturn=$?
    if [ 0 -ne $iReturn ]; then
        exit $iReturn
    fi
    cd $m_DIR_SCRIPT
    shift
done

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
notice "Now is: `/bin/date -R`"
