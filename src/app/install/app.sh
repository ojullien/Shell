## -----------------------------------------------------------------------------
## Install.
## Install App functions.
##
## @package ojullien\Shell\app\clean
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Constants
## -----------------------------------------------------------------------------
readonly m_INSTALL_DIR_REALPATH="${m_DIR_APP}/install"

## -----------------------------------------------------------------------------
## functions
## -----------------------------------------------------------------------------
Install::showHelp() {
    String::notice "Usage: $(basename "$0") [options]"
    String::notice "\tConfigure a fresh install."
    Option::showHelp
    return 0
}

## -----------------------------------------------------------------------------
## mlocate
## -----------------------------------------------------------------------------
Install::updateMlocate() {

    # Init
    local -i iReturn=1

    # Do the job
    String::notice -n "Update a database for mlocate:"
    updatedb
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}
