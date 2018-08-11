## -----------------------------------------------------
## Save host-specific system-wide configuration
## App Configuration file.
##
## @category Linux Scripts
## @package saveSystemConf
## @version 20180811
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

# Remove these lines once you have configured this file
echo "The 'app/savesystemconf/cfg/savesystemconf.cfg.sh' file is not configured !!!"
String::error "The 'app/savesystemconf/cfg/savesystemconf.cfg.sh' file is not configured !!!"
exit 3

## -----------------------------------------------------
## Destination folder
## -----------------------------------------------------
declare m_SAVECONF_SAVEFOLDER="/home/<user>/out"

## -----------------------------------------------------
## Trace
## -----------------------------------------------------
String::separateLine
String::notice "App configuration: saveSystemConf"
FileSystem::checkDir "\tDefault save directory:\t${m_SAVECONF_SAVEFOLDER}" "${m_SAVECONF_SAVEFOLDER}"
