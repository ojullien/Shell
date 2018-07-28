#!/bin/sh

## -----------------------------------------------------------------------------
## Linux Scripts.
## Install system.
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
. "./sys/inc/option.inc"
. "./sys/inc/apt.inc"
. "./sys/inc/service.inc"
. "./app/install/inc/install.inc"

## -----------------------------------------------------------------------------
## Load common configuration
## -----------------------------------------------------------------------------
. "./sys/cfg/main.cnf"
. "./sys/cfg/root.cnf"
. "./app/install/cfg/install.cnf"

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
separateLine
notice "Today is: `/bin/date -R`"
notice "The PID for `/usr/bin/basename $0` process is: $$"
waitUser

## -----------------------------------------------------------------------------
## Initial update and upgrade
## -----------------------------------------------------------------------------
separateLine
notice "Update source.list"
moveFile $m_SOURCELIST_SYS_PATH $m_SOURCELIST_SAVE_PATH.$m_DATE
copyFile $m_SOURCELIST_WRK_PATH.`lsb_release --short --codename` $m_SOURCELIST_SYS_PATH
waitUser

isInstalled aptitude
iAptitude=$?
if [ 0 -eq $iAptitude ]; then
    updateAndUpgrade
else
    upgradeWithAptget
    separateLine
    apt-get install -qqy aptitude
    iReturn=$?
    notice -n "Installing aptitude:"
    if [ 0 -eq $iReturn ]; then
        success "OK"
    else
        error "NOK code: $iReturn"
    fi
fi
waitUser

## -----------------------------------------------------------------------------
## Install or modify Bashrc files
## -----------------------------------------------------------------------------
configureBashrc $m_APP_INSTALL_WRK_DIR $m_APP_INSTALL_SAVE_DIR
configureBashAliases
waitUser

## -----------------------------------------------------------------------------
## Configure swap
## -----------------------------------------------------------------------------
configureSwap
waitUser

## -----------------------------------------------------------------------------
## Uninstall packages
## -----------------------------------------------------------------------------
uninstallPackage $m_PACKAGES_PURGE
waitUser

## -----------------------------------------------------------------------------
## Install packages system
## -----------------------------------------------------------------------------
installPackage $m_PACKAGES_SYSTEM
waitUser

## -----------------------------------------------------------------------------
## Install packages system without recommanded
## -----------------------------------------------------------------------------
installPackage $m_PACKAGES_SYSTEM_NORECOMMENDS
waitUser

## -----------------------------------------------------------------------------
## Install packages apps
## -----------------------------------------------------------------------------
installPackage $m_PACKAGES_APP
waitUser

## -----------------------------------------------------------------------------
## Logwatch
## -----------------------------------------------------------------------------
notice "Configure Logwatch"
configureLogwatch $m_LOGWATCH_SOURCE $m_LOGWATCH_DESTINATION
waitUser

## -----------------------------------------------------------------------------
## Vim
## -----------------------------------------------------------------------------
notice "Update vimrc.local"
copyFile $m_VIMRCLOCAL_WRK_PATH $m_VIMRCLOCAL_SYS_PATH
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
## Optimize SSD
## -----------------------------------------------------------------------------
separateLine
notice "Optimize SSD"
isSSD && supportTRIM && optimizeSSD $m_FSTRIM_CRON
waitUser

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
notice "Now is: `/bin/date -R`"