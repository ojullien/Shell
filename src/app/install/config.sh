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

## -----------------------------------------------------
## Packages
## -----------------------------------------------------
readonly m_INSTALL_PACKAGES_PURGE="vim-tiny"
readonly m_INSTALL_PACKAGES_SYSTEM="dkms build-essential util-linux deborphan localepurge hdparm htop ntp tzdata ntpdate debsums"
readonly m_INSTALL_PACKAGES_SYSTEM_NORECOMMENDS="--without-recommends smartmontools"
readonly m_INSTALL_PACKAGES_APP="vim fail2ban ftp mlocate chkrootkit logwatch"




readonly m_INSTALL_VIMRCLOCAL_FILENAME="vimrc.local"
readonly m_INSTALL_VIMRCLOCAL_PATH_SYS="/etc/vim/${m_INSTALL_VIMRCLOCAL_FILENAME}"





readonly m_FSTRIM_CRON="/etc/cron.weekly/fstrim"


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
