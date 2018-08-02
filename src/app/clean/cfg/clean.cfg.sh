## -----------------------------------------------------
## Clean logs.
## App Configuration file.
##
## @category Linux Scripts
## @package Clean
## @version 20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

readonly m_CLEAN_FILES="*.gz *.old *.1 *.2 *.log.*"

## -----------------------------------------------------
## Trace
## -----------------------------------------------------
String::separateLine
String::notice "App configuration: Clean"
String::notice "\tFiles to delete:"
String::notice  "\t\t${m_CLEAN_FILES}"
