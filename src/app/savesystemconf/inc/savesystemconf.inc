## -----------------------------------------------------
## Linux Scripts.
## saveSystemConf App functions
##
## @category  Linux Scripts
## @package   saveSystemConf
## @version   20170813
## @copyright (©) 2017, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

saveConf () {
    if [ $# -eq 0 ] || [ -z "$1" ]; then
        error "Usage: saveConf <directory>"
        exit 1
    fi

    # Source does not exist
    [ ! -d "/etc/$1" ] && error "ERROR: Directory /etc/$1 does not exist!" && return 1

    # Destination does not exist
    [ ! -d "/home/ojullien/out" ] && error "ERROR: Directory /home/ojullien/out does not exist!" && return 1

    # Change directory
    cd /etc

    # Saving
    m_Save="/home/ojullien/out/$(uname -n)-$1-$(/bin/date +"%Y%m%d").tar.bz2"
    tar cjf $m_Save $1
    iReturn=$?
    if [ 0 -eq $iReturn ]; then
        success "Saving $1 to $m_Save."
    else
        error "ERROR: Can not save $1. code: $iReturn"
    fi

    return $iReturn
}
