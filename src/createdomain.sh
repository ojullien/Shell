#!/bin/bash

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
. "${m_DIR_SYS_INC}/string.inc.sh"
. "${m_DIR_SYS_INC}/filesystem.inc.sh"
. "${m_DIR_APP}/createdomain/inc/createdomain.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "${m_DIR_APP}/createdomain/cfg/createdomain.cfg.sh"
. "${m_DIR_SYS_CFG}/main.cfg.sh"
. "${m_DIR_SYS_CFG}/root.cfg.sh"

## -----------------------------------------------------------------------------
## Must have an argument
## -----------------------------------------------------------------------------
[ $# -eq 0 ] && Console::display "Usage: createDomain <domain 1> [domain 2] ..." && exit 2

until [ -z "${1+defined}" ]  # Until all parameters used up . . .
do
    FileSystem::createDirectory $1 && createGroup $1 && createUser $1 && changeOwner $1
    iReturn=$?
    if [ 0 -ne $iReturn ]; then
        exit $iReturn
    fi
    shift
done

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"