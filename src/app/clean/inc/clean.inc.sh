## -----------------------------------------------------
## Linux Scripts.
## Clean App functions
##
## @category Linux Scripts
## @package Clean
## @version 20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

Clean::truncateLog() {
    local -i iReturn
    String::notice -n "Truncate all files in /var/log:"
    find /var/log -type f -exec truncate -s 0 {} \;
    iReturn=$?
    if (( 0 == iReturn )); then
        String::success  "OK"
    else
        String::error "NOK code: ${iReturn}"
    fi
    return ${iReturn}
}

Clean::cleanLog() {
    local -i iReturn
    if [[ -n "$1" ]]; then
        for myFile in "$@"
        do
            findToRemove "/var/log" "${myFile}"
            iReturn=$?
        done
    else
        String::error "Usage: cleanLog <file extension 1> <file extension 2> <...>"
        exit 1
    fi
    return ${iReturn}
}

Clean::cleanSpecificLog() {
    if [[ $# -lt 2 ]] || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: cleanSpecificLog <dir in /var/log> <file extension>"
        exit 1
    fi
    local sDir="$1"
    local sExtension="$2"
    local -i iReturn
    if [[ -d "/var/log/${sDir}" ]]; then
        findToRemove "/var/log${sDir}" "${sExtension}"
        iReturn=$?
    else
        String::notice "Directory var/log/${sDir} does not exist."
        iReturn=0
    fi
    return ${iReturn}
}

Clean::processCleanLog() {
    String::notice "Clean logs"
    Clean::cleanSpecificLog "exim4" "*log.*"
    Clean::cleanSpecificLog "apache2_evasive" "dos-*"
    Clean::cleanSpecificLog "apache2" "*.log"
    Clean::cleanSpecificLog "php7.0" "*.log"
    Clean::cleanSpecificLog "php7.0" "*.slow"
    Clean::cleanSpecificLog "php5" "*.log"
    Clean::cleanLog "${m_CLEAN_FILES}"
    Clean::truncateLog
}
