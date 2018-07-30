## -----------------------------------------------------
## Linux Scripts.
## Managing services
##
## @category Linux Scripts
## @package Includes
## @version 20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

if [[ -e "/bin/systemctl" ]]; then
    . "${m_DIR_SYS_INC}/systemD.inc.sh"
else
    . "${m_DIR_SYS_INC}/systemV.inc.sh"
fi

Service::disableServices() {
    String::separateLine
    String::notice "Disable services"
    if [[ -n "$1" ]]; then
        for myService in "$@"
        do
            if [[ -e "/etc/init.d/${myService}" ]]; then
                Service::stopService "${myService}"
                Service::disableService "${myService}"
            fi
        done
    else
        String::error "Usage: disableServices <service 1> <service 2> <...>"
        exit 1
    fi
    return 0
}

Service::stopServices() {
    String::separateLine
    String::notice "Stop services"
    if [[ -n "$1" ]]; then
        for myService in "$@"
        do
            if [ -e "/etc/init.d/${myService}" ]; then
                Service::stopService "${myService}"
            fi
        done
    else
        String::error "Usage: stopServices <service 1> <service 2> <...>"
        exit 1
    fi
    return 0
}

Service::startServices() {
    String::separateLine
    String::notice "Start services"
    if [[ -n "$1" ]]; then
        for myService in "$@"
        do
            if [ -e "/etc/init.d/${myService}" ]; then
                startService "${myService}"
            fi
        done
    else
        String::error "Usage: startService <service 1> <service 2> <...>"
        exit 1
    fi
    return 0
}
