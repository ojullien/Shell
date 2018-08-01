## -----------------------------------------------------
## Linux Scripts.
## Save web site folder App Configuration file.
##
## @category Linux Scripts
## @package SaveSite
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
declare m_SAVESITE_SAVEFOLDER="/home/<user>/out"

## -----------------------------------------------------
## Trace
## -----------------------------------------------------
String::separateLine
String::notice "App configuration: saveSite"
FileSystem::checkDir "\tDefault save directory:\t${m_SAVESITE_SAVEFOLDER}" "${m_SAVESITE_SAVEFOLDER}"
