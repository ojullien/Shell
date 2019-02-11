## -----------------------------------------------------------------------------
## Linux Scripts.
## DisableServices App functions
##
## @package ojullien\Shell\app\manageservices
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

ManageServices::help() {
    String::notice "Usage: $(basename "$0") <disable | start | stop>"
    String::notice "\tDisable, start or stop a list of services defined in the config.sh file"
}

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
ManageServices::trace() {
    String::separateLine
    String::notice "App configuration: ManageServices"
    String::notice "\tServices to disable:"
    String::notice  "\t\t${m_SERVICES_DISABLE}"
    String::notice "\tServices to stop:"
    String::notice  "\t\t${m_SERVICES_STOP}"
    String::notice "\tServices to start:"
    String::notice  "\t\t${m_SERVICES_START}"
    return 0
}
