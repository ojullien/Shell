## -----------------------------------------------------------------------------
## sources list.
## sources list install package functions.
##
## @package ojullien\Shell\app\install\pkg\sources.list
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Constants
## -----------------------------------------------------------------------------
readonly m_INSTALL_SOURCESLIST_DIR_REALPATH="$(realpath "$(dirname "$0")")"
readonly m_INSTALL_SOURCESLIST_FILENAME="sources.list"
readonly m_INSTALL_SOURCESLIST_SYS="/etc/apt/${m_INSTALL_SOURCESLIST_FILENAME}"

## -----------------------------------------------------------------------------
## Functions
## -----------------------------------------------------------------------------
SourcesList::configure() {

    # Parameters
    if (( $# != 1 )) || [[ -z "$1" ]]; then
        String::error "Usage: SourcesList::configure <release codename>"
        return 1
    fi

    # Init
    local sCodeName="$1"
    local -i iReturn=0

    # Save current conf
    FileSystem::moveFile "${m_INSTALL_SOURCESLIST_SYS}" "${m_INSTALL_SOURCESLIST_DIR_REALPATH}/conf_saved/${m_DATE}_${m_INSTALL_SOURCESLIST_FILENAME}"

    # Install new one
    FileSystem::copyFile "${m_INSTALL_SOURCESLIST_DIR_REALPATH}/conf_new/${sCodeName}" "${m_INSTALL_SOURCESLIST_SYS}"
    iReturn=$?

    return ${iReturn}
}
