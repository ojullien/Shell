## -----------------------------------------------------
## Linux Scripts.
## Managing services with SystemD
##
## @category  Linux Scripts
## @package   Includes
## @version   20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

## -----------------------------------------------------
## Stops service
## -----------------------------------------------------

stopService () {
    if [ $# -lt 1 ] || [ -z "$1" ]; then
        error "Usage: stopService <name>"
        exit 1
    fi
    notice -n "Stopping $1:"
    /bin/systemctl stop $1.service > /dev/null 2>&1
    iReturn=$?
    if [ 0 -eq $iReturn ]; then
        success "OK"
    else
        error "NOK code: $iReturn"
    fi
    return $iReturn
}

## -----------------------------------------------------
## Starts service
## -----------------------------------------------------

startService () {
    if [ $# -lt 1 ] || [ -z "$1" ]; then
        error "Usage: startService <name>"
        exit 1
    fi
    notice -n "Starting $1:"
    /bin/systemctl start $1.service > /dev/null 2>&1
    iReturn=$?
    if [ 0 -eq $iReturn ]; then
        success "OK"
    else
        error "NOK code: $iReturn"
    fi
    return $iReturn
}

## -----------------------------------------------------
## Disables service
## -----------------------------------------------------

disableService () {
    if [ $# -lt 1 ] || [ -z "$1" ]; then
        error "Usage: disableService <name>"
        exit 1
    fi
    notice -n "Disabling $1:"
    /bin/systemctl disable $1.service > /dev/null 2>&1
    iReturn=$?
    if [ 0 -eq $iReturn ]; then
        success "OK"
    else
        error "NOK code: $iReturn"
    fi
    return $iReturn
}

## -----------------------------------------------------
## Status service
## -----------------------------------------------------

statusService () {
    if [ $# -lt 1 ] || [ -z "$1" ]; then
        error "Usage: statusService <name>"
        exit 1
    fi
    notice -n "Status $1:"
    /bin/systemctl status $1.service > /dev/null 2>&1
    iReturn=$?
    case $iReturn in
        0)
            notice "is running"
            ;;
        3)
            notice "is stopped"
            ;;
        *)
            error "ERROR code: $iReturn"
    esac
    return $iReturn
}