## -----------------------------------------------------------------------------
## Linux Scripts.
## Clean app functions
##
## @package ojullien\Shell\app\clean
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

Clean::truncateLog() {

    # Init
    local -i iReturn=1

    # Do the job
    String::notice -n "Truncate all files in /var/log:"
    find /var/log -type f -exec truncate -s 0 {} \;
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

Clean::cleanLog() {

    # Parameters
    if (($# == 0)) || [[ -z "$1" ]]; then
        String::error "Usage: Clean::cleanLog <file extension 1> <file extension 2> <...>"
        return 1
    fi

    # Do the job
    while [[ -n "${1+defined}" ]]; do
        FileSystem::findToRemove "/var/log" "$1"
        shift
    done

    return 0
}

Clean::cleanSpecificLog() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: Clean::cleanSpecificLog <dir in /var/log> <file extension>"
        exit 1
    fi

    # Init
    local sDir="$1" sExtension="$2"
    local -i iReturn=1

    # Do the job
    if [[ -d "/var/log/${sDir}" ]]; then
        FileSystem::findToRemove "/var/log/${sDir}" "${sExtension}"
        iReturn=$?
    else
        String::notice "Directory '/var/log/${sDir}' does not exist."
        iReturn=0
    fi

    return ${iReturn}
}

Clean::main() {

    # Parameters
    if (( ${#m_CLEAN_SPEC_DIR[*]} != ${#m_CLEAN_SPEC_FILES[*]} )); then
        String::error "Configuration error. Array sizes are not valid."
        return 1
    fi

    # Init
    declare -i iIndex=0

    # Do the job
    String::notice "Clean logs..."

    # Clean specific directories
    for iIndex in ${!m_CLEAN_SPEC_DIR[*]}
    do
        Clean::cleanSpecificLog "${m_CLEAN_SPEC_DIR[$iIndex]}" "${m_CLEAN_SPEC_FILES[$iIndex]}"
    done

    # Clean all other log files
    Clean::cleanLog ${m_CLEAN_FILES}

    # Truncate the rest
    Clean::truncateLog

    return 0
}

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
Clean::trace() {

    # Init
    declare -i iIndex=0

    # Do the job
    String::separateLine
    String::notice "App configuration: Clean"
    String::notice "\tFiles to delete in /var/log:"
    String::notice "\t\t${m_CLEAN_FILES}"
    String::notice "\tDirectories to clean in /var/log:"
    for iIndex in ${!m_CLEAN_SPEC_DIR[*]}
    do
        String::notice "\t\t${m_CLEAN_SPEC_DIR[$iIndex]}/${m_CLEAN_SPEC_FILES[$iIndex]}"
    done

    return 0
}
