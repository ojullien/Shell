#!/bin/bash

## -----------------------------------------------------------------------------
## Linux Scripts.
## Install the Shell project into the /root/work directory.
##
## @category Linux Scripts
## @package installShell
## @version 20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------------------------------

## -----------------------------------------------------
## Date
## -----------------------------------------------------
readonly m_DATE="$(date +"%Y%m%d")_$(date +"%H%M")"

## -----------------------------------------------------
## Constants
## -----------------------------------------------------

# Directory holds scripts
readonly m_DIR_SCRIPT="$(pwd)"
# Working directory
readonly m_DIR="$(dirname "${m_DIR_SCRIPT}")"
# Directory source
readonly m_DIR_SRC="${m_DIR}/src"
# Directory holds system files
readonly m_DIR_SYS="${m_DIR_SRC}/sys"
# Directory holds configuration system files
readonly m_DIR_SYS_CFG="${m_DIR_SYS}/cfg"
# Directory holds include system files
readonly m_DIR_SYS_INC="${m_DIR_SYS}/inc"
# Directory holds app files
readonly m_DIR_APP="${m_DIR_SRC}/app"
# Directory destination
readonly m_DIR_DEST="/root/work"
# Directory to install
readonly m_PROJECT_NAME="Shell"

## -----------------------------------------------------
## Main Files
## -----------------------------------------------------
readonly m_LOGFILE="${m_DIR_SCRIPT}/${m_DATE}_$(basename "$0").log"
local -i iReturn

## -----------------------------------------------------------------------------
## Includes
## -----------------------------------------------------------------------------
. "${m_DIR_SYS_INC}/string.inc.sh"
. "${m_DIR_SYS_INC}/filesystem.inc.sh"
. "${m_DIR_SYS_INC}/option.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "${m_DIR_SYS_CFG}/root.cfg.sh"
. "${m_DIR_SYS_CFG}/main.cfg.sh"

String::separateLine
String::notice "App configuration: installShell"
FileSystem::checkDir "\tSource directory:\t${m_DIR_SRC}" "${m_DIR_SRC}"
FileSystem::checkDir "\tDestination directory:\t${m_DIR_DEST}" "${m_DIR_DEST}"
String::notice "\tProject name:\t\t${m_PROJECT_NAME}"

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename "$0") process is: $$"
Console::waitUser

FileSystem::removeDirectory "${m_DIR_DEST}/${m_PROJECT_NAME}"
iReturn=$?
((0!=iReturn)) && return ${iReturn}

FileSystem::createDirectory "${m_DIR_DEST}"
iReturn=$?
((0!=iReturn)) && return ${iReturn}

FileSystem::moveFile "${m_DIR_SRC}" "${m_DIR_DEST}/${m_PROJECT_NAME}"
iReturn=$?
((0!=iReturn)) && return ${iReturn}

String::notice -n "Change owner:"
chown -R root:root "${m_DIR_DEST}/${m_PROJECT_NAME}"
iReturn=$?
String::checkReturnValueForTruthiness ${iReturn}
((0!=iReturn)) && return ${iReturn}

String::notice -n "Change directories access rights:"
find "${m_DIR_DEST}/${m_PROJECT_NAME}" -type d -exec chmod u=rwx,g=rx,o= {} \;
iReturn=$?
String::checkReturnValueForTruthiness ${iReturn}
((0!=iReturn)) && return ${iReturn}

String::notice -n "Change files access rights:"
find "${m_DIR_DEST}/${m_PROJECT_NAME}" -type f -exec chmod u=rw,g=r,o= {} \;
iReturn=$?
String::checkReturnValueForTruthiness ${iReturn}
((0!=iReturn)) && return ${iReturn}

String::notice -n "Change sh files access rights:"
chmod u+x ${m_DIR_DEST}/${m_PROJECT_NAME}/*.sh
iReturn=$?
String::checkReturnValueForTruthiness ${iReturn}
((0!=iReturn)) && return ${iReturn}

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
exit ${iReturn}
