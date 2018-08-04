## -----------------------------------------------------------------------------
## Fills disks with zero for compression.
## App functions
##
## @category Linux Scripts
## @package fillWithZeros
## @version 20180804
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------------------------------

FillWithZeros::fill() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: FillWithZeros::fill <mount point as string>"
        exit 1
    fi

    # Init
    local sDir="$1"
    local -i iReturn

    # Do the job
    String::notice "Filling '${sDir}' with zeros ..."
    cd "${sDir}" || return 1
    cat /dev/zero > zeros
    sync
    rm -f zeros
    iReturn=$?
    String::notice -n "Fill '${sDir}' with zeros:"
    String::checkReturnValueForTruthiness ${iReturn}
    cd "${m_DIR_SCRIPT}" || return 1

    return ${iReturn}
}
