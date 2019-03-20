## -----------------------------------------------------------------------------
## Linux Scripts.
## Install app configuration file.
##
## @package ojullien\Shell\app\install
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

# Remove these 3 lines once you have configured this file
echo "The 'app/install/config.sh' file is not configured !!!"
String::error "The 'app/install/config.sh' file is not configured !!!"
exit 3

## -----------------------------------------------------------------------------
## User other than root for whom we need to configure
## .bashrc, .bash_aliases and vim
## -----------------------------------------------------------------------------
readonly m_INSTALL_USERS=("<user>")

## -----------------------------------------------------------------------------
## Directories
## -----------------------------------------------------------------------------

# Directory holds new configuration files
readonly m_INSTALL_CONFIGURATION_NEW="${m_DIR_APP}/install/conf/%s/new/%s"
# Directory holds old configuration files
readonly m_INSTALL_CONFIGURATION_OLD="${m_DIR_APP}/install/conf/%s/old/%s"

## -----------------------------------------------------------------------------
## Sources list files
## -----------------------------------------------------------------------------
readonly m_INSTALL_SOURCELIST_FILENAME="sources.list"
readonly m_INSTALL_SOURCELIST_SYS="/etc/apt/${m_INSTALL_SOURCELIST_FILENAME}"

## -----------------------------------------------------
## Bashrc files
## -----------------------------------------------------
readonly m_INSTALL_BASHRC_FILENAME="bashrc"











## -----------------------------------------------------
## Packages
## -----------------------------------------------------
readonly m_PACKAGES_PURGE="vim-tiny"
readonly m_PACKAGES_SYSTEM="dkms build-essential util-linux deborphan localepurge hdparm ntp tzdata ntpdate debsums"
readonly m_PACKAGES_SYSTEM_NORECOMMENDS="--without-recommends smartmontools"
readonly m_PACKAGES_APP="aptitude vim fail2ban ftp mlocate chkrootkit logwatch"





readonly m_INSTALL_VIMRCLOCAL_FILENAME="vimrc.local"
readonly m_INSTALL_VIMRCLOCAL_PATH_SYS="/etc/vim/${m_INSTALL_VIMRCLOCAL_FILENAME}"





readonly m_FSTRIM_CRON="/etc/cron.weekly/fstrim"

readonly m_LOGWATCH_SOURCE="${m_INSTALL_WRK_DIR}/logwatch"
readonly m_LOGWATCH_DESTINATION="/etc/logwatch/conf"

## -----------------------------------------------------
## Trace
## -----------------------------------------------------
String::separateLine
String::notice "App configuration: Install"
FileSystem::checkDir "\tApp directory:\t${m_INSTALL_WRK_DIR}" "${m_INSTALL_WRK_DIR}"
String::notice "\tPackages to install:"
String::notice  "\t\t${m_PACKAGES_SYSTEM}"
String::notice  "\t\t${m_PACKAGES_SYSTEM_NORECOMMENDS}"
String::notice  "\t\t${m_PACKAGES_APP}"
String::notice "\tPackages to uninstall:"
String::notice  "\t\t${m_PACKAGES_PURGE}"
