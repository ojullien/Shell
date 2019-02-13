## -----------------------------------------------------------------------------
## Linux Scripts.
## SaveSite app configuration file.
##
## @package ojullien\Shell\app\savesite
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

# Remove these 3 lines once you have configured this file
echo "The 'app/savesite/cfg/savesite.cfg.sh' file is not configured !!!"
String::error "The 'app/savesite/config.sh' file is not configured !!!"
exit 3

## -----------------------------------------------------------------------------
## Destination folder
## -----------------------------------------------------------------------------
readonly m_SAVESITE_DESTINATION_DEFAULT="/home/<user>"
readonly m_APACHE2_DOCUMENTROOT="/var/www"

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
SaveSite::trace() {
    String::separateLine
    String::notice "App configuration: saveSite"
    FileSystem::checkDir "\tDefault destination directory:\t${m_SAVESITE_DESTINATION_DEFAULT}" "${m_SAVESITE_DESTINATION_DEFAULT}"
    return 0
}
