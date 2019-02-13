## -----------------------------------------------------------------------------
## Linux Scripts.
## SaveSystemConf app configuration file.
##
## @package ojullien\Shell\app\savesystemconf
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

# Remove these 3 lines once you have configured this file
echo "The 'app/savesystemconf/config.sh' file is not configured !!!"
String::error "The 'app/savesystemconf/config.sh' file is not configured !!!"
exit 3

## -----------------------------------------------------------------------------
## Destination folder
## -----------------------------------------------------------------------------
readonly m_SAVESYSTEMCONF_DESTINATION_DEFAULT="/home/<user>"

## -----------------------------------------------------------------------------
## Source folder
## -----------------------------------------------------------------------------
readonly m_SYSTEM_CONFIGURATION_FOLDER="/etc"

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
SaveSystemConf::trace() {
    String::separateLine
    String::notice "App configuration: saveSystemConf"
    FileSystem::checkDir "\tDefault destination directory:\t${m_SAVESITE_DESTINATION_DEFAULT}" "${m_SAVESITE_DESTINATION_DEFAULT}"
    FileSystem::checkDir "\tSystem configuration directory:\t${m_SYSTEM_CONFIGURATION_FOLDER}" "${m_SYSTEM_CONFIGURATION_FOLDER}"
    return 0
}
