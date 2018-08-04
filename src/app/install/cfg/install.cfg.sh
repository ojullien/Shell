## -----------------------------------------------------
## Linux Scripts.
## Install App Configuration file.
##
## @category Linux Scripts
## @package Install
## @version 20180804
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

# Remove these lines once you have configured this file
echo "The app/install/cfg/install.cfg.sh file is not configured !!!"
String::error "The app/install/cfg/install.cfg.sh file is not configured !!!"
exit 3

## -----------------------------------------------------
## User other than root for whom we need to configure
## .bashrc, .bash_aliases and vim
## -----------------------------------------------------
readonly m_APP_INSTALL_USER="<user>"

## -----------------------------------------------------
## Directories
## -----------------------------------------------------

# Directory holds source files
readonly m_APP_INSTALL_WRK_DIR="${m_DIR_APP}/install/wrk"

# Directory holds saved files
readonly m_APP_INSTALL_SAVE_DIR="${m_DIR_APP}/install/save"

## -----------------------------------------------------
## Packages
## -----------------------------------------------------
readonly m_PACKAGES_PURGE="vim-tiny"
readonly m_PACKAGES_SYSTEM="dkms build-essential util-linux deborphan localepurge hdparm"
readonly m_PACKAGES_SYSTEM_NORECOMMENDS="--without-recommends smartmontools"
readonly m_PACKAGES_APP="vim fail2ban ftp mlocate chkrootkit logwatch"

## -----------------------------------------------------
## Files
## -----------------------------------------------------
readonly m_SOURCELIST_NAME="sources.list"
readonly m_SOURCELIST_SYS_PATH="/etc/apt/${m_SOURCELIST_NAME}"
readonly m_SOURCELIST_WRK_PATH="${m_APP_INSTALL_WRK_DIR}/${m_SOURCELIST_NAME}"
readonly m_SOURCELIST_SAVE_PATH="${m_APP_INSTALL_SAVE_DIR}/${m_SOURCELIST_NAME}"

readonly m_VIMRCLOCAL_NAME="vimrc.local"
readonly m_VIMRCLOCAL_SYS_PATH="/etc/vim/${m_VIMRCLOCAL_NAME}"
readonly m_VIMRCLOCAL_WRK_PATH="${m_APP_INSTALL_WRK_DIR}/${m_VIMRCLOCAL_NAME}"

readonly m_FSTRIM_CRON="/etc/cron.weekly/fstrim"

readonly m_LOGWATCH_SOURCE="${m_APP_INSTALL_WRK_DIR}/logwatch"
readonly m_LOGWATCH_DESTINATION="/etc/logwatch/conf"

## -----------------------------------------------------
## Trace
## -----------------------------------------------------
String::separateLine
String::notice "App configuration: Install"
FileSystem::checkDir "\tApp directory:\t${m_APP_INSTALL_WRK_DIR}" "${m_APP_INSTALL_WRK_DIR}"
String::notice "\tPackages to install:"
String::notice  "\t\t${m_PACKAGES_SYSTEM}"
String::notice  "\t\t${m_PACKAGES_SYSTEM_NORECOMMENDS}"
String::notice  "\t\t${m_PACKAGES_APP}"
String::notice "\tPackages to uninstall:"
String::notice  "\t\t${m_PACKAGES_PURGE}"
