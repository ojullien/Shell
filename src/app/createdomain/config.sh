## -----------------------------------------------------------------------------
## Linux Scripts.
## CreateDomain app configuration file.
##
## @package ojullien\Shell\app\createdomain
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

readonly m_APACHE2_DOCUMENTROOT="/var/www"
readonly m_APACHE2_LOGDIR="/var/log/apache2"
readonly m_APACHE2_GROUP="www-data"

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
CreateDomain::trace() {
        String::separateLine
        String::notice "App configuration: createDomain"
        String::notice "\tApache2 document root:\t${m_APACHE2_DOCUMENTROOT}"
        String::notice "\tApache2 log dir:\t${m_APACHE2_LOGDIR}"
        String::notice "\tApache2 group:\t\t${m_APACHE2_GROUP}"
    return 0
}
