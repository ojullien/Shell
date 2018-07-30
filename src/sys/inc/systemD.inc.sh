## -----------------------------------------------------
## Linux Scripts.
## Managing services with SystemD
##
## @category Linux Scripts
## @package Includes
## @version 20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

## -----------------------------------------------------
## Stops service
## -----------------------------------------------------

Service::stopService() {
    if (($# < 1)) || [[ -z "$1" ]]; then
        String::error "Usage: stopService <name>"
        exit 1
    fi
    local -i iReturn
    local sService="$1"
    String::notice -n "Stopping '${sService}':"
    systemctl stop "${sService}.service" > /dev/null 2>&1
    iReturn=$?
    if (( 0 == iReturn )); then
        String::success "OK"
    else
        String::error "NOK code: ${iReturn}"
    fi
    return ${iReturn}
}

## -----------------------------------------------------
## Starts service
## -----------------------------------------------------

Service::startService() {
    if (($# < 1)) || [[ -z "$1" ]]; then
        String::error "Usage: startService <name>"
        exit 1
    fi
    local -i iReturn
    local sService="$1"
    String::notice -n "Starting '${sService}':"
    systemctl start "${sService}.service" > /dev/null 2>&1
    iReturn=$?
    if (( 0 == iReturn )); then
        String::success "OK"
    else
        String::error "NOK code: ${iReturn}"
    fi
    return ${iReturn}
}

## -----------------------------------------------------
## Disables service
## -----------------------------------------------------

Service::disableService() {
    if (($# < 1)) || [[ -z "$1" ]]; then
        String::error "Usage: disableService <name>"
        exit 1
    fi
    local -i iReturn
    local sService="$1"
    String::notice -n "Disabling '${sService}':"
    systemctl disable "${sService}.service" > /dev/null 2>&1
    iReturn=$?
    if (( 0 == iReturn )); then
        String::success "OK"
    else
        String::error "NOK code: ${iReturn}"
    fi
    return ${iReturn}
}

## -----------------------------------------------------
## Status service
## -----------------------------------------------------

Service::statusService() {
    if (($# < 1)) || [[ -z "$1" ]]; then
        String::error "Usage: statusService <name>"
        exit 1
    fi
    local -i iReturn
    local sService="$1"
    String::notice -n "Status '${sService}':"
    systemctl status "${sService}.service" > /dev/null 2>&1
    iReturn=$?
    case "${iReturn}" in
        0)
            String::notice "is running"
            ;;
        3)
            String::notice "is stopped"
            ;;
        *)
            String::error "ERROR code: ${iReturn}"
    esac
    return ${iReturn}
}
