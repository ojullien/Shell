#!/bin/bash
## -----------------------------------------------------------------------------
## Linux Scripts.
## Fills disks with zero for compression.
##
## @package ojullien\Shell\app\fillwithzeros
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------
#set -o errexit
set -o nounset
set -o pipefail

## -----------------------------------------------------------------------------
## Shell scripts directory, eg: /root/work/Shell/src/bin
## -----------------------------------------------------------------------------
readonly m_DIR_REALPATH="$(realpath "$(dirname "$0")")"

## -----------------------------------------------------------------------------
## Load constants
## -----------------------------------------------------------------------------
# shellcheck source=/dev/null
. "${m_DIR_REALPATH}/../app/fillwithzeros/app.sh"
exit 0







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
. "${m_DIR_SYS_INC}/service.inc.sh"
. "${m_DIR_APP}/clean/inc/clean.inc.sh"
. "${m_DIR_APP}/fillwithzeros/inc/fillwithzeros.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "${m_DIR_SYS_CFG}/root.cfg.sh"
. "${m_DIR_SYS_CFG}/main.cfg.sh"
. "${m_DIR_APP}/disableservices/cfg/disableservices.cfg.sh"
. "${m_DIR_APP}/clean/cfg/clean.cfg.sh"
. "${m_DIR_APP}/fillwithzeros/inc/fillwithzeros.inc.sh"

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
String::separateLine
Service::disableServices ${m_SERVICES_DISABLE}
String::separateLine
Service::stopServices ${m_SERVICES_STOP}
Console::waitUser

## -----------------------------------------------------------------------------
## Clean logs
## -----------------------------------------------------------------------------
String::separateLine
Clean::main
Console::waitUser

## -----------------------------------------------------------------------------
## Fill
## -----------------------------------------------------------------------------

declare sDisk="" sMount=""
declare -a aDisks

mapfile -t aDisks < <(lsblk --noheadings --nodeps --list --output NAME)

for sDisk in "${aDisks[@]}"; do
    if [[ ${sDisk} =~ ^sd(.*) ]]; then
        sMount=$(findmnt --noheadings --output TARGET "/dev/${sDisk}1")
        [[ -n ${sMount} ]] && FillWithZeros::fill "${sMount}"
    fi
done

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
String::notice "Ready to shutdown!"
Console::waitUser

Service::shutdownSystem
