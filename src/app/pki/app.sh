## -----------------------------------------------------------------------------
## Linux Scripts.
## Public Key Infrastructure (PKI) management toolkit functions
##
## @package ojullien\Shell\app\pki
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

PKI::showHelp() {
    String::notice "Usage: $(basename "$0") [options] [command]"
    String::notice "\tPKI toolkit"
    Option::showHelp
    String::notice "Available Commands:"
    String::notice "\trootlevel\tSample minimal PKI Root level application."
    return 0
}
