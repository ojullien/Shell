## -----------------------------------------------------
## Linux Scripts.
## Install App Configuration file.
##
## @category  Linux Scripts
## @package   Install
## @version     20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

## -----------------------------------------------------
## Directories
## -----------------------------------------------------

# Directory holds source files
m_APP_INSTALL_WRK_DIR=$m_DIR_APP/install/wrk

# Directory holds saved files
m_APP_INSTALL_SAVE_DIR=$m_DIR_APP/install/save

## -----------------------------------------------------
## Packages
## -----------------------------------------------------
m_PACKAGES_PURGE="vim-tiny"
m_PACKAGES_SYSTEM="dkms build-essential util-linux deborphan localepurge hdparm"
m_PACKAGES_SYSTEM_NORECOMMENDS="--without-recommends smartmontools"
m_PACKAGES_APP="vim fail2ban ftp mlocate chkrootkit logwatch"

## -----------------------------------------------------
## Files
## -----------------------------------------------------
m_SOURCELIST_NAME=sources.list
m_SOURCELIST_SYS_PATH=/etc/apt/$m_SOURCELIST_NAME
m_SOURCELIST_WRK_PATH=$m_APP_INSTALL_WRK_DIR/$m_SOURCELIST_NAME
m_SOURCELIST_SAVE_PATH=$m_APP_INSTALL_SAVE_DIR/$m_SOURCELIST_NAME

m_VIMRCLOCAL_NAME=vimrc.local
m_VIMRCLOCAL_SYS_PATH=/etc/vim/$m_VIMRCLOCAL_NAME
m_VIMRCLOCAL_WRK_PATH=$m_APP_INSTALL_WRK_DIR/$m_VIMRCLOCAL_NAME

m_FSTRIM_CRON=/etc/cron.weekly/fstrim

m_LOGWATCH_SOURCE=$m_APP_INSTALL_WRK_DIR/logwatch
m_LOGWATCH_DESTINATION=/etc/logwatch/conf

## -----------------------------------------------------
## Trace
## -----------------------------------------------------
separateLine
notice "App configuration: Install"
checkDir "\tApp directory:\t${m_APP_INSTALL_WRK_DIR}" $m_APP_INSTALL_WRK_DIR
notice "\tPackages to install:"
notice  "\t\t${m_PACKAGES_SYSTEM}"
notice  "\t\t${m_PACKAGES_SYSTEM_NORECOMMENDS}"
notice  "\t\t${m_PACKAGES_APP}"
notice "\tPackages to uninstall:"
notice  "\t\t${m_PACKAGES_PURGE}"
