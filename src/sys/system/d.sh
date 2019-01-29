## -----------------------------------------------------------------------------
## Linux Scripts.
## Managing services with SystemD
##
## @package ojullien\Shell\sys\service
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Disable
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
    systemctl -q is-enabled "${sService}" > /dev/null 2>&1
    iReturn=$?

    return ${iReturn}
}

Service::disable() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Service::disable <service>"
        return 1
    fi

    # Init
    local -i iReturn=0
    local sService="$1"

    # Do the job
    String::notice -n "Disabling '${sService}' service:"
    if systemctl -q is-enabled "${sService}"; then
        systemctl -q disable "${sService}" > /dev/null 2>&1
        iReturn=$?
    fi
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Shutting down the system
## -----------------------------------------------------------------------------

Service::shutdown() {
    systemctl -q poweroff
    return 0
}
