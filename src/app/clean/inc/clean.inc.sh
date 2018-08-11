## -----------------------------------------------------
## Clean logs.
## App functions
##
## @category Linux Scripts
## @package Clean
## @version 20180811
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

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
        exit 1
    fi

    # Do the job
    while [[ "${1+defined}" ]]; do
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
    String::notice "Clean logs..."
    Clean::cleanSpecificLog "exim4" "*log.*"
    Clean::cleanSpecificLog "apache2_evasive" "dos-*"
    Clean::cleanSpecificLog "apache2" "*.log"
    Clean::cleanSpecificLog "php7.0" "*.log"
    Clean::cleanSpecificLog "php7.0" "*.slow"
    Clean::cleanSpecificLog "php5" "*.log"
    Clean::cleanLog ${m_CLEAN_FILES}
    Clean::truncateLog
}
