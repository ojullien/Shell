#!/bin/bash

## -----------------------------------------------------------------------------
## Linux Scripts.
## Creates an apache user/group and a home directory in /var/www.
##
## @category Linux Scripts
## @package createdomain.cfg
## @version 20180804
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
. "${m_DIR_SYS_INC}/option.inc.sh"
. "${m_DIR_APP}/createdomain/inc/createdomain.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "${m_DIR_SYS_CFG}/root.cfg.sh"
. "${m_DIR_SYS_CFG}/main.cfg.sh"
. "${m_DIR_APP}/createdomain/cfg/createdomain.cfg.sh"

## -----------------------------------------------------
## Parse the app options and arguments
## -----------------------------------------------------
declare -i iReturn

while (( "$#" )); do
    case "$1" in
    -*|--*=) # unknown option
        shift
        String::separateLine
        Domain::showHelp
        exit 0
        ;;
    *) # We presume its a domain name
        String::separateLine
        Domain::create "$1"
        iReturn=$?
        ((0!=iReturn)) && exit ${iReturn}
        shift
        Console::waitUser
        ;;
    esac
done

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
exit 0
