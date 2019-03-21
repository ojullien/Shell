## -----------------------------------------------------------------------------
## Logwatch.
## Logwatch install package functions.
##
## @package ojullien\Shell\app\install\pkg\logwatch
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Constants
## -----------------------------------------------------------------------------
readonly m_INSTALL_LOGWATCH_DIR_REALPATH="$(realpath "$(dirname "$0")")"
readonly m_INSTALL_LOGWATCH_FILENAME="logwatch.conf"
readonly m_INSTALL_LOGWATCH_SYS="/etc/logwatch/conf"

## -----------------------------------------------------------------------------
## Functions
## -----------------------------------------------------------------------------
LogWatch::configure() {

    # Init
    local sFile="" sCurrent="${m_INSTALL_LOGWATCH_SYS}/${m_INSTALL_LOGWATCH_FILENAME}"
    local -i iReturn=1
    local -a aFiles

    # save current conf
    FileSystem::moveFile "${sCurrent}" "${m_INSTALL_LOGWATCH_DIR_REALPATH}/conf_saved/${m_DATE}_${m_INSTALL_LOGWATCH_FILENAME}"

    # Install new one
    FileSystem::copyFile "${m_INSTALL_LOGWATCH_DIR_REALPATH}/conf_new/${m_INSTALL_LOGWATCH_FILENAME}" "${sCurrent}"
    iReturn=$?
    ((0!=iReturn)) && return ${iReturn}

    # save current logfiles conf & install new ones
    mapfile -t aFiles < <(find "${m_INSTALL_LOGWATCH_SYS}/logfiles" -type f -iname '*.conf' -printf "%f\n")
    iReturn=$?
    ((0!=iReturn)) && return ${iReturn}

    for sFile in "${aFiles[@]}"; do
        sCurrent="${m_INSTALL_LOGWATCH_SYS}/logfiles/${sFile}"
        FileSystem::moveFile "${sCurrent}" "${m_INSTALL_LOGWATCH_DIR_REALPATH}/conf_saved/logfiles/${m_DATE}_${sFile}"
        FileSystem::copyFile "${m_INSTALL_LOGWATCH_DIR_REALPATH}/conf_new/logfiles/${sFile}" "${sCurrent}"
        iReturn=$?
        ((0!=iReturn)) && return ${iReturn}
    done

    # Change owner
    String::notice -n "Change owner:"
    chown root:root "${m_INSTALL_LOGWATCH_SYS}/logwatch.conf" "${m_INSTALL_LOGWATCH_SYS}/logfiles/"*".conf"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}
