## -----------------------------------------------------
## Linux Scripts.
## saveSystemConf App functions
##
## @category  Linux Scripts
## @package   saveSystemConf
## @version   20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

SaveSite::save() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: SaveSite::save <source as folder path> <destination as folder path>"
        exit 1
    fi

    # Init
    local sSource="$1" sDestination="$2"
    local m_Save
    local -i iReturn

    # Source does not exist
    if [[ ! -d "/var/www/${sSource}" ]]; then
        String::error "ERROR: Directory /var/www/${sSource} does not exist!"
        return 1
    fi

    # Destination does not exist
    if [[ ! -d "${sDestination}" ]]; then
        String::error "ERROR: Directory ${sDestination} does not exist!"
        return 1
    fi

    # Change directory
    cd /var/www || return 1

    # Saving
    m_Save="${sDestination}/$(uname -n)-${sSource}-$(date +"%Y%m%d").tar.bz2"
    String::notice -n "Saving ${sSource} to ${m_Save}:"
    tar cjf "${m_Save}" "${sSource}"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}
