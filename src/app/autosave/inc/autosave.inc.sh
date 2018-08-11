## -----------------------------------------------------
## Autosave
## App functions
##
## @category Linux Scripts
## @package Autosave
## @version 20180811
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

AutoSave::watchLog() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: AutoSave::watchLog <logwatch file>"
        exit 1
    fi

    # Init
    local sFile="$1"
    local -i iReturn=1

    # Do the job
    String::notice "Log parsing and analyzing ..."
    logwatch --filename "${sFile}"
    iReturn=$?
    String::notice -n "logwatch:"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}
