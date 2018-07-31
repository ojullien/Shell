## -----------------------------------------------------
## Linux Scripts.
## Managing services with SystemV
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

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Service::stopService <name>"
        exit 1
    fi

    # Init
    local -i iReturn
    local sService="$1"

    # Do the job
    String::notice -n "'${sService}' is stopping:"
    service "${sService}" stop > /dev/null 2>&1
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------
## Starts service
## -----------------------------------------------------

Service::startService() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Service::startService <name>"
        exit 1
    fi

    # Init
    local -i iReturn
    local sService="$1"

    # Do the job
    String::notice -n "'${sService}' is starting:"
    service "${sService}" start > /dev/null 2>&1
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------
## Disables service
## -----------------------------------------------------

Service::disableService() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Service::disableService <name>"
        exit 1
    fi

    # Init
    local -i iReturn
    local sService="$1"

    # Do the job
    String::notice -n "'${sService}' is disabling:"
    update-rc.d -f "${sService}" remove  > /dev/null 2>&1
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------
## Status service
## -----------------------------------------------------

Service::statusService() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Service::statusService <name>"
        exit 1
    fi

    # Init
    local -i iReturn
    local sService="$1"

    # Do the job
    String::notice -n "'${sService}' status is:"
    service "${sService}" status > /dev/null 2>&1
    iReturn=$?
    case ${iReturn} in
        0)
            String::notice "running"
            ;;
        3)
            String::notice "stopped"
            ;;
        *)
            String::error "ERROR code: ${iReturn}"
    esac
    return "${iReturn}"
}
