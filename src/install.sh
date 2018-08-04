#!/bin/bash

## -----------------------------------------------------------------------------
## Linux Scripts.
## Install system.
##
## @category  Linux Scripts
## @package   Scripts
## @version   20180728
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
. "${m_DIR_SYS_INC}/apt.inc.sh"
. "${m_DIR_SYS_INC}/service.inc.sh"
. "${m_DIR_APP}/install/inc/install.inc.sh"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "${m_DIR_SYS_CFG}/root.cfg.sh"
. "${m_DIR_SYS_CFG}/main.cfg.sh"
if [[ -f "${m_DIR_APP}/install/cfg/priv-install.cfg.sh" ]]; then
    . "${m_DIR_APP}/install/cfg/priv-install.cfg.sh"
else
    . "${m_DIR_APP}/install/cfg/install.cfg.sh"
fi

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename "$0") process is: $$"
Console::waitUser

## -----------------------------------------------------------------------------
## Initial update and upgrade
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Updating source.list ..."
FileSystem::copyFile "${m_SOURCELIST_SYS_PATH}" "${m_SOURCELIST_SAVE_PATH}.${m_DATE}"
declare sRelease="$(lsb_release --short --codename)"
if [[ -z "${sRelease}" ]] || [[ "n/a" = "${sRelease}" ]]; then
    sRelease='testing'
fi
FileSystem::copyFile "${m_SOURCELIST_WRK_PATH}.${sRelease}" "${m_SOURCELIST_SYS_PATH}"
Console::waitUser

declare -i iReturn

String::separateLine
Apt::isInstalled "aptitude"
iReturn=$?
if ((0 == iReturn )); then
    Apt::updateAndUpgrade
else
    Apt::upgradeWithAptget
    String::separateLine
    String::notice "Installing aptitude ..."
    apt-get install -qqy "aptitude"
    iReturn=$?
    String::notice -n "Install aptitude:"
    String::checkReturnValueForTruthiness ${iReturn}
fi
Console::waitUser

## -----------------------------------------------------------------------------
## Install or modify Bashrc files
## -----------------------------------------------------------------------------
String::separateLine
Install::configureBashrc "${m_APP_INSTALL_WRK_DIR}" "${m_APP_INSTALL_SAVE_DIR}" "${m_APP_INSTALL_USER}"
String::separateLine
Install::configureBashAliases "${m_APP_INSTALL_USER}"
Console::waitUser

## -----------------------------------------------------------------------------
## Configure swap
## -----------------------------------------------------------------------------
String::separateLine
Install::configureSwap
Console::waitUser

## -----------------------------------------------------------------------------
## Uninstall packages
## -----------------------------------------------------------------------------
String::separateLine
Apt::uninstallPackage ${m_PACKAGES_PURGE}
Console::waitUser

## -----------------------------------------------------------------------------
## Install packages system
## -----------------------------------------------------------------------------
String::separateLine
Apt::installPackage ${m_PACKAGES_SYSTEM}
Console::waitUser

## -----------------------------------------------------------------------------
## Install packages system without recommanded
## -----------------------------------------------------------------------------
String::separateLine
Apt::installPackage ${m_PACKAGES_SYSTEM_NORECOMMENDS}
Console::waitUser

## -----------------------------------------------------------------------------
## Install packages apps
## -----------------------------------------------------------------------------
String::separateLine
Apt::installPackage ${m_PACKAGES_APP}
Console::waitUser

## -----------------------------------------------------------------------------
## Logwatch
## -----------------------------------------------------------------------------
String::separateLine
Install::configureLogwatch "${m_LOGWATCH_SOURCE}" "${m_LOGWATCH_DESTINATION}"
Console::waitUser

## -----------------------------------------------------------------------------
## Vim
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Updating vimrc.local ..."
FileSystem::copyFile "${m_VIMRCLOCAL_WRK_PATH}" "${m_VIMRCLOCAL_SYS_PATH}"
Console::waitUser

## -----------------------------------------------------------------------------
## Mlocate
## -----------------------------------------------------------------------------
String::separateLine
Install::updateMlocate
Console::waitUser

## -----------------------------------------------------------------------------
## Optimize SSD
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Optimizing SSD ..."
Install::isSSD
iReturn=$?
if ((0 == iReturn )); then
    Install::supportTRIM
    iReturn=$?
    if ((0 == iReturn )); then
        Install::optimizeSSD ${m_FSTRIM_CRON}
        iReturn=$?
    fi
else
    iReturn=0
fi
String::notice -n "Optimize SSD:"
String::checkReturnValueForTruthiness ${iReturn}
Console::waitUser

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
exit 0
