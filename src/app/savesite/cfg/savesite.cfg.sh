## -----------------------------------------------------
## Linux Scripts.
## saveSystemConf App Configuration file.
##
## @category  Linux Scripts
## @package   savesite
## @version   20180728
## @copyright (©) 2018, Olivier Jullien <https://github.com/ojullien>
## -----------------------------------------------------

m_OPTION_DISPLAY=1
m_OPTION_LOG=0
m_OPTION_WAIT=0

# Remove these lines once you have configured this file
echo "The app/savesite/cfg/savesite.cfg.sh file is not configured !!!"
error "The app/savesite/cfg/savesite.cfg.sh file is not configured !!!"
exit 3

## -----------------------------------------------------
## Destination folder
## -----------------------------------------------------
m_SAVESITE_SAVEFOLDER=/home/<user>/out

## -----------------------------------------------------
## Trace
## -----------------------------------------------------
separateLine
notice "App configuration: saveSite"
notice "\tDisplay mode is ON. Contents will be displayed."
notice "\tLog mode is OFF. Contents will not be logged."
notice "\tWait mode is OFF. Do not wait for user input between actions."
checkDir "\tSave directory:\t${m_SAVESITE_SAVEFOLDER}" $m_SAVESITE_SAVEFOLDER
