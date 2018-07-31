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
. "${m_DIR_SYS_CFG}/main.cfg.sh"
. "${m_DIR_SYS_CFG}/root.cfg.sh"
. "${m_DIR_APP}/install/cfg/install.cfg.sh"

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
String::notice "Update source.list"
FileSystem::moveFile ${m_SOURCELIST_SYS_PATH} ${m_SOURCELIST_SAVE_PATH}.${m_DATE}
FileSystem::copyFile ${m_SOURCELIST_WRK_PATH}.`lsb_release --short --codename` ${m_SOURCELIST_SYS_PATH}
Console::waitUser

Apt::isInstalled aptitude
iAptitude=$?
if [ 0 -eq $iAptitude ]; then
    Apt::updateAndUpgrade
else
    Apt::upgradeWithAptget
   String::separateLine
    apt-get install -qqy aptitude
    iReturn=$?
   String::notice -n "Installing aptitude:"
    if (( 0 == iReturn )); then
       String::success "OK"
    else
       String::error "NOK code: ${iReturn}"
    fi
fi
Console::waitUser

## -----------------------------------------------------------------------------
## Install or modify Bashrc files
## -----------------------------------------------------------------------------
Install::configureBashrc ${m_APP_INSTALL_WRK_DIR} ${m_APP_INSTALL_SAVE_DIR} ${m_APP_INSTALL_USER}
configureBashAliases
Console::waitUser

## -----------------------------------------------------------------------------
## Configure swap
## -----------------------------------------------------------------------------
configureSwap
Console::waitUser

## -----------------------------------------------------------------------------
## Uninstall packages
## -----------------------------------------------------------------------------
Apt::uninstallPackage ${m_PACKAGES_PURGE}
Console::waitUser

## -----------------------------------------------------------------------------
## Install packages system
## -----------------------------------------------------------------------------
installPackage ${m_PACKAGES_SYSTEM}
Console::waitUser

## -----------------------------------------------------------------------------
## Install packages system without recommanded
## -----------------------------------------------------------------------------
installPackage ${m_PACKAGES_SYSTEM}_NORECOMMENDS
Console::waitUser

## -----------------------------------------------------------------------------
## Install packages apps
## -----------------------------------------------------------------------------
installPackage ${m_PACKAGES_APP}
Console::waitUser

## -----------------------------------------------------------------------------
## Logwatch
## -----------------------------------------------------------------------------
String::notice "Configure Logwatch"
configureLogwatch ${m_LOGWATCH_SOURCE} ${m_LOGWATCH_DESTINATION}
Console::waitUser

## -----------------------------------------------------------------------------
## Vim
## -----------------------------------------------------------------------------
String::notice "Update vimrc.local"
FileSystem::copyFile ${m_VIMRCLOCAL_WRK_PATH} ${m_VIMRCLOCAL_SYS_PATH}
Console::waitUser

## -----------------------------------------------------------------------------
## Mlocate
## -----------------------------------------------------------------------------
String::notice -n "Updating a database for mlocate:"
updatedb
iReturn=$?
if (( 0 == iReturn )); then
   String::success "OK"
else
   String::error "NOK code: ${iReturn}"
fi
Console::waitUser

## -----------------------------------------------------------------------------
## Optimize SSD
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Optimize SSD"
isSSD && supportTRIM && optimizeSSD ${m_FSTRIM_CRON}
Console::waitUser

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
