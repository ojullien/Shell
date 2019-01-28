## -----------------------------------------------------------------------------
## Linux Scripts.
## Managing services
##
## @package ojullien\Shell\sys
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

if [[ -d "/run/systemd/system" ]]; then
    # shellcheck source=/dev/null
    . "${m_DIR_SYS}/system/d.sh"
else
    # shellcheck source=/dev/null
    . "${m_DIR_SYS}/system/v.sh"
fi

## -----------------------------------------------------------------------------
## Stops service
## -----------------------------------------------------------------------------

Service::stop() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Service::stop <service>"
        return 1
    fi

    # Init
    local -i iReturn=0
    local sService="$1"

    # Do the job
    String::notice -n "Stopping '${sService}' service:"
    if service --status-all | grep -wq "${sService}$"; then
        service "${sService}" stop > /dev/null 2>&1
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    else
        String::success "not loaded"
    fi

    return ${iReturn}
}

Service::stopServices() {

    # Parameters
    if [[ -z "$1" ]]; then
        String::error "Usage: Service::stopServices <service 1> <service 2> <...>"
        return 1
    fi

    # Init
    local -i iReturn=0

    # Do the job
    String::notice "Stopping '$*' services..."
    for myService in "$@"
    do
        Service::stop "${myService}"
        ((iReturn+=$?))
    done

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Disables service
## -----------------------------------------------------------------------------

Service::disableServices() {

    # Parameters
    if [[ -z "$1" ]]; then
        String::error "Usage: Service::disableServices <service 1> <service 2> <...>"
        return 1
    fi

    # Init
    local -i iReturn=0

    # Do the job
    String::notice "Disabling '$*' services..."
    for myService in "$@"
    do
        Service::stop "${myService}"
        ((iReturn+=$?))
        Service::disable "${myService}"
        ((iReturn+=$?))
    done

    return ${iReturn}
}


Service::startServices() {
    String::notice "Starting '$*' services..."
    if [[ -n "$1" ]]; then
        for myService in "$@"
        do
            if [ -e "/etc/init.d/${myService}" ]; then
               Service::startService "${myService}"
            fi
        done
    else
        String::error "Usage: Service::startService <service 1> <service 2> <...>"
        exit 1
    fi
    return 0
}

Service::statusServices() {
    String::notice "Getting status for '$*' services..."
    if [[ -n "$1" ]]; then
        for myService in "$@"
        do
            if [ -e "/etc/init.d/${myService}" ]; then
               Service::statusService "${myService}"
            fi
        done
    else
        String::error "Usage: Service::statusServices <service 1> <service 2> <...>"
        exit 1
    fi
    return 0
}

## -----------------------------------------------------------------------------
## Shutting down the system
## -----------------------------------------------------------------------------

Service::shutdownSystem() {
    Service::shutdown
    return 0
}
