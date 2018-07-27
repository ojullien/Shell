## -----------------------------------------------------
## Linux Scripts.
## Managing services
##
## @category    Linux Scripts
## @package     Includes
## @version     20170904
## @copyright (©) 2017, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

if [ -e "/bin/systemctl" ]; then
	. "./sys/inc/systemD.inc"
else
	. "./sys/inc/systemV.inc"
fi

disableServices () {
    separateLine
    notice "Disable services"
    if [ -n "$1" ]; then
        for myService in $@
        do
            if [ -e "/etc/init.d/$myService" ]; then
                stopService $myService
                disableService $myService
            fi
        done
    else
        error "Usage: disableServices <service 1> <service 2> <...>"
        exit 1
    fi
    return 0
}

stopServices () {
    separateLine
    notice "Stop services"
    if [ -n "$1" ]; then
        for myService in $@
        do
            if [ -e "/etc/init.d/$myService" ]; then
                stopService $myService
            fi
        done
    else
        error "Usage: stopServices <service 1> <service 2> <...>"
        exit 1
    fi
    return 0
}

startServices () {
    separateLine
    notice "Start services"
    if [ -n "$1" ]; then
        for myService in $@
        do
            if [ -e "/etc/init.d/$myService" ]; then
                startService $myService
            fi
        done
    else
        error "Usage: startService <service 1> <service 2> <...>"
        exit 1
    fi
    return 0
}