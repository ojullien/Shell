## -----------------------------------------------------------------------------
## swap.
## swap install package functions.
##
## @package ojullien\Shell\app\install\pkg\swap
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Constants
## -----------------------------------------------------------------------------
readonly m_INSTALL_SWAP_DIR_REALPATH="$(realpath "$(dirname "$0")")"
readonly m_INSTALL_SWAP_FILENAME="99-swappiness.conf"

## -----------------------------------------------------------------------------
## Functions
## -----------------------------------------------------------------------------
Swap::configure() {

    # Init
    local sFile="/etc/sysctl.d/${m_INSTALL_SWAP_FILENAME}"
    local -i iReturn=1

    # Save current conf
    FileSystem::moveFile "${sFile}" "${m_INSTALL_SWAP_DIR_REALPATH}/conf_saved/${m_DATE}_${m_INSTALL_SWAP_FILENAME}"

    # Install new one
    String::notice -n "\tCurrent swappiness:"
    cat /proc/sys/vm/swappiness
    String::notice "\tWrite ${sFile}"
    echo vm.swappiness=5 | tee "${sFile}"
    echo vm.vfs_cache_pressure=50 | tee -a "${sFile}"
    String::notice "\tRead values from ${sFile}"
    sysctl -p "${sFile}"
    String::notice "\tDisable devices and files for paging and swapping"
    swapoff -av
    String::notice "\tEnable devices and files for paging and swapping"
    swapon -av
    iReturn=$?
    String::notice -n "\tCurrent swappiness:"
    cat /proc/sys/vm/swappiness

    return ${iReturn}
}
