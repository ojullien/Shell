## -----------------------------------------------------
## Linux Scripts.
## saveSystemConf App Configuration file.
##
## @category Linux Scripts
## @package savesite
## @version 20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

# Remove these lines once you have configured this file
echo "The 'app/savesite/cfg/savesite.cfg.sh' file is not configured !!!"
String::error "The 'app/savesite/cfg/savesite.cfg.sh' file is not configured !!!"
exit 3

## -----------------------------------------------------
## Destination folder
## -----------------------------------------------------
readonly m_SAVESITE_SAVEFOLDER="/home/<user>/out"

## -----------------------------------------------------
## Trace
## -----------------------------------------------------
String::separateLine
String::notice "App configuration: saveSite"
FileSystem::checkDir "\tSave directory:\t${m_SAVESITE_SAVEFOLDER}" "${m_SAVESITE_SAVEFOLDER}"
