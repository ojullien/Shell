## -----------------------------------------------------
## Linux Scripts.
## saveSystemConf App functions
##
## @category Linux Scripts
## @package saveSystemConf
## @version 20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

SaveSystemConf::save() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
       String::error "Usage: SaveSystemConf::save <conf directory> <save directory>"
        exit 1
    fi

    # Init
    local sSource="$1" sDestination="$2"
    local m_Save
    local -i iReturn

    # Source does not exist
    if [[ ! -d "/etc/${sSource}" ]]; then
        String::error "ERROR: Directory /etc/${sSource} does not exist!"
        return 1
    fi

    # Destination does not exist
    if [[ ! -d "${sDestination}" ]]; then
        String::error "ERROR: Directory ${sDestination} does not exist!"
        return 1
    fi

    # Change directory
    cd /etc || return 1

    # Saving
    m_Save="${sDestination}/$(uname -n)-${sSource}-$(date +"%Y%m%d").tar.bz2"
    String::notice -n "Saving ${sSource} to ${m_Save}:"
    tar cjf "${m_Save}" "${sSource}"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}
