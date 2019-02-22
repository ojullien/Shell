## -----------------------------------------------------------------------------
## Linux Scripts.
## DisableServices App functions
##
## @package ojullien\Shell\app\manageservices
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

ManageServices::showHelp() {
    String::notice "Usage: $(basename "$0") <disable | start | stop>"
    String::notice "\tDisable, start or stop a list of services defined in the config.sh file"
    Option::showHelp
    return 0
}
