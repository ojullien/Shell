#!/bin/bash
## -----------------------------------------------------------------------------
## Linux Scripts.
## Install system.
##
## @package ojullien\Shell\bin
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
. "${m_DIR_REALPATH}/../sys/constant.sh"

## -----------------------------------------------------------------------------
## Includes sources & configuration
## -----------------------------------------------------------------------------
# shellcheck source=/dev/null
. "${m_DIR_SYS}/runasroot.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/string.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/filesystem.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/option.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/config.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/package.sh"
# shellcheck source=/dev/null
#. "${m_DIR_SYS}/service.sh"
#Config::load "manageservices"
Config::load "install"
# shellcheck source=/dev/null
. "${m_DIR_APP}/install/app.sh"

## -----------------------------------------------------------------------------
## Help
## -----------------------------------------------------------------------------
((m_OPTION_SHOWHELP)) && Option::showHelp && exit 0

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
Constant::trace
Install::trace

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename "$0") process is: $$"
Console::waitUser

## -----------------------------------------------------------------------------
## Configures sources file
## -----------------------------------------------------------------------------
String::separateLine
declare sSaved="" sNew="" sRelease="" sUser=""
sRelease=$(Install::getRelease)
printf -v sSaved "${m_INSTALL_CONFIGURATION_OLD}" "${m_INSTALL_SOURCELIST_FILENAME}" "${m_INSTALL_SOURCELIST_FILENAME}_${m_DATE}"
printf -v sNew "${m_INSTALL_CONFIGURATION_NEW}" "${m_INSTALL_SOURCELIST_FILENAME}" "${sRelease}"
Install::configureSourcesList "${m_INSTALL_SOURCELIST_SYS}" "${sSaved}" "${sNew}"
Console::waitUser

## -----------------------------------------------------------------------------
## Updates & upgrades
## -----------------------------------------------------------------------------
String::separateLine
Package::upgrade
Console::waitUser

## -----------------------------------------------------------------------------
## Configures .bashrc
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Configuring root .bashrc ..."
printf -v sSaved "${m_INSTALL_CONFIGURATION_OLD}" "${m_INSTALL_BASHRC_FILENAME}" ".${m_INSTALL_BASHRC_FILENAME}_root_${m_DATE}"
printf -v sNew "${m_INSTALL_CONFIGURATION_NEW}" "${m_INSTALL_BASHRC_FILENAME}" "root"
Install::configureBashRC "/root/.${m_INSTALL_BASHRC_FILENAME}" "${sSaved}" "${sNew}" "root"
Console::waitUser

String::separateLine
String::notice "Configuring users .bashrc ..."
for sUser in "${m_INSTALL_USERS[@]}"; do
    printf -v sSaved "${m_INSTALL_CONFIGURATION_OLD}" "${m_INSTALL_BASHRC_FILENAME}" ".${m_INSTALL_BASHRC_FILENAME}_${sUser}_${m_DATE}"
    printf -v sNew "${m_INSTALL_CONFIGURATION_NEW}" "${m_INSTALL_BASHRC_FILENAME}" "user"
    Install::configureBashRC "/home/${sUser}/.${m_INSTALL_BASHRC_FILENAME}" "${sSaved}" "${sNew}" "${sUser}"
done
Console::waitUser

## -----------------------------------------------------------------------------
## Configures .bash_alias
## -----------------------------------------------------------------------------
String::separateLine
Install::configureBashAliases "/root"
Console::waitUser
for sUser in "${m_INSTALL_USERS[@]}"; do
    Install::configureBashAliases "/home/${sUser}"
done
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
