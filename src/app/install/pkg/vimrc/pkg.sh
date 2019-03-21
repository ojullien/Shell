## -----------------------------------------------------------------------------
## vimrc.
## vimrc install package functions.
##
## @package ojullien\Shell\app\install\pkg\vimrc
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Constants
## -----------------------------------------------------------------------------
readonly m_INSTALL_VIMRC_DIR_REALPATH="${m_INSTALL_DIR_REALPATH}/pkg/vimrc"
readonly m_INSTALL_VIMRC_FILENAME="vimrc.local"
readonly m_INSTALL_VIMRC_SYS="/etc/vim/${m_INSTALL_VIMRC_FILENAME}"

## -----------------------------------------------------------------------------
## Functions
## -----------------------------------------------------------------------------
VimRC::configure() {

    # Init
    local -i iReturn=1

    # Save current conf
    FileSystem::moveFile "${m_INSTALL_VIMRC_SYS}" "${m_INSTALL_VIMRC_DIR_REALPATH}/conf_saved/${m_DATE}_${m_INSTALL_VIMRC_FILENAME}"

    # Install new one
    FileSystem::copyFile "${m_INSTALL_VIMRC_DIR_REALPATH}/conf_new/${m_INSTALL_VIMRC_FILENAME}" "${m_INSTALL_VIMRC_SYS}"
    iReturn=$?

    return ${iReturn}
}
