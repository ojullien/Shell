## -----------------------------------------------------
## Linux Scripts.
## saveSystemConf App functions
##
## @category  Linux Scripts
## @package   saveSystemConf
## @version   20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

saveSite () {
    if [ $# -lt 2 ] || [ -z "$1" ] || [ -z "$2" ]; then
        error "Usage: saveConf <source as folder path> <destination as folder path>"
        exit 1
    fi

    # Source does not exist
    [ ! -d "/var/www/$1" ] && error "ERROR: Directory /var/www/$1 does not exist!" && return 1

    # Destination does not exist
    [ ! -d "$2" ] && error "ERROR: Directory $2 does not exist!" && return 1

    # Change directory
    cd /var/www

    # Saving
    m_Save="$2/$(uname -n)-$1-$(/bin/date +"%Y%m%d").tar.bz2"
    tar cjf $m_Save $1
    iReturn=$?
    if [ 0 -eq $iReturn ]; then
        success "Saving $1 to $m_Save."
    else
        error "ERROR: Can not save $1. code: $iReturn"
    fi

    return $iReturn
}
