## -----------------------------------------------------------------------------
## Linux Scripts.
## Managing services with SystemV
##
## @package ojullien\Shell\sys\service
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Disables service
## -----------------------------------------------------------------------------

Service::disableService() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Service::disableService <service>"
        return 1
    fi

    # Init
    local -i iReturn=0
    local sService="$1"

    # Do the job
    String::notice -n "Disabling '${sService}' service:"
    if [[ -x "${SERVICEDIR}/${SERVICE}" ]]; then
        update-rc.d -f "${sService}" remove > /dev/null 2>&1
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    else
        String::success "unrecognized service"
    fi

    return ${iReturn}
}


## -----------------------------------------------------------------------------
## Starts service
## -----------------------------------------------------------------------------

Service::startService() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Service::startService <name>"
        exit 1
    fi

    # Init
    local -i iReturn=1
    local sService="$1"

    # Do the job
    String::notice -n "starting '${sService}' service:"
    service "${sService}" start > /dev/null 2>&1
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}



## -----------------------------------------------------------------------------
## Status service
## -----------------------------------------------------------------------------

Service::statusService() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Service::statusService <name>"
        exit 1
    fi

    # Init
    local -i iReturn=1
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

## -----------------------------------------------------------------------------
## Shutting down the system
## -----------------------------------------------------------------------------

Service::shutdown() {
    shutdown -h now
    return 0
}
