## -----------------------------------------------------
## Linux Scripts.
## Clean App functions
##
## @category  Linux Scripts
## @package   Clean
## @version   20170806
## @copyright (©) 2017, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

truncateLog () {
    notice -n "Truncate all files in /var/log:"
    find /var/log -type f -exec truncate -s 0 {} \;
    iReturn=$?
    if [ 0 -eq $iReturn ]; then
        success "OK"
    else
        error "NOK code: $iReturn"
    fi
    return $iReturn
}

cleanLog () {
    if [ -n "$1" ]; then
        for myFile in $@
        do
            findToRemove "/var/log" $myFile
            iReturn=$?
        done
    else
        error "Usage: cleanLog <file extension 1> <file extension 2> <...>"
        exit 1
    fi
    return $iReturn
}

cleanSpecificLog () {
    if [ $# -lt 2 ] || [ -z "$1" ] || [ -z "$2" ]; then
        error "Usage: cleanSpecificLog <dir in /var/log> <file extension>"
        exit 1
    fi
    if [ -d /var/log/$1 ]; then
        findToRemove "/var/log/$1" $2
        iReturn=$?
    else
        notice "Directory var/log/$1 does not exist."
        iReturn=0
    fi
    return $iReturn
}

processCleanLog () {
    notice "Clean logs"
    cleanSpecificLog "exim4" "*log.*"
    cleanSpecificLog "apache2_evasive" "dos-*"
    cleanSpecificLog "apache2" "*.log"
    cleanSpecificLog "php7.0" "*.log"
    cleanSpecificLog "php7.0" "*.slow"
    cleanLog $m_CLEAN_FILES
    truncateLog
}