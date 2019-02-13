## -----------------------------------------------------------------------------
## Linux Scripts.
## AutoSave app functions
##
## @package ojullien\Shell\app\autosave
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------


AutoSave::watchLog() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: AutoSave::watchLog <logwatch file>"
        return 1
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
