## -----------------------------------------------------------------------------
## Linux Scripts.
## Managing services with SystemD
##
## @package ojullien\Shell\sys\service
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Disables service
## -----------------------------------------------------------------------------

Service::isEnabled() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Service::isEnabled <service>"
        return 1
    fi

    # Init
    local -i iReturn=0
    local sService="$1"

    # Do the job
    if systemctl -q is-enabled "${sService}"; then
        iReturn=1
    fi

    return ${iReturn}
}

Service::disable() {

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
    if Service::isEnabled "${sService}"; then
        systemctl -q disable "${sService}" > /dev/null 2>&1
        iReturn=$?
    fi
    String::checkReturnValueForTruthiness ${iReturn}

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
    String::notice -n "Starting '${sService}' service:"
    systemctl start "${sService}.service" > /dev/null 2>&1
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
    systemctl status "${sService}.service" > /dev/null 2>&1
    iReturn=$?
    case "${iReturn}" in
        0)
            String::notice "running"
            ;;
        3)
            String::notice "stopped"
            ;;
        *)
            String::error "ERROR code: ${iReturn}"
    esac
    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Shutting down the system
## -----------------------------------------------------------------------------

Service::shutdown() {
    systemctl poweroff
    return 0
}
